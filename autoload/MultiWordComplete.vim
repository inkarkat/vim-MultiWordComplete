" MultiWordComplete.vim Insert mode completion that completes a sequence of words based on anchor characters for each word.
"
" DEPENDENCIES:
"   - CompleteHelper.vim plugin
"   - ingo-library.vim plugin
"
" Copyright: (C) 2010-2019 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
let s:save_cpo = &cpo
set cpo&vim

function! s:GetCompleteOption()
    return ingo#plugin#setting#GetBufferLocal('MultiWordComplete_complete', &complete)
endfunction

function! s:IsAlpha( expr )
    return (a:expr =~# '^\a\+$')
endfunction
function! s:BuildRegexp( base )
    " Each alphabetic character is an anchor for the beginning of a word.
    " All other (keyword) characters must just match at that position.
    let l:anchors = map(split(a:base, '\zs'), 'escape(v:val, "\\")')

    " Assemble all regexp fragments together to build the full regexp.
    " There is a strict regexp which is tried first and a relaxed regexp to fall
    " back on.
    let l:regexpFragments = []
    let l:currentFragment = ''
    let l:i = 0
    while l:i < len(l:anchors)
	let l:anchor = l:anchors[l:i]
	let l:previousAnchor = get(l:anchors, l:i - 1, '')
	let l:nextAnchor = get(l:anchors, l:i + 1, '')

	if s:IsAlpha(l:anchor)
	    " If an anchor is alphabetic, match a word fragment that starts with
	    " the anchor.
	    if l:i > 0 && s:IsAlpha(l:previousAnchor)
		call add(l:regexpFragments, l:currentFragment)
		let l:currentFragment = ''
	    endif
	    let l:currentFragment .= l:anchor . '\k*'
	else
	    " If an anchor is a non-alphabetic character, match either a word
	    " fragment that starts with the it, or just match the it.
	    if ! empty(l:currentFragment)
		" This may (cardinality = *) be a new word fragment starting
		" with the non-letter. Because of the different cardinality, directly
		" append this here to the current fragment instead of relying on
		" the eventual joining of word fragments.
		let l:currentFragment .= '\%(\k\@!\_.\)*'
	    endif
	    if s:IsAlpha(l:nextAnchor)
		" An alphabetic anchor following a non-alphabetic one may either
		" immediately match after it (like any other non-alphabetic
		" keyword character, creating a joint anchor). Or it may
		" represent a word fragment of its own. In this case, we
		" directly append the next alphabetic anchor here instead of
		" relying on the eventual joining of word fragments.
		let l:currentFragment .= l:anchor . '\%(\k*\%(\k\@!\_.\)\+\)\?' . l:nextAnchor . '\k*'

		" The next anchor has already been processed, skip it in the
		" loop.
		let l:i += 1
	    else
		let l:currentFragment .= l:anchor . '\k*'
	    endif
	endif
	let l:i += 1
    endwhile
    if ! empty(l:currentFragment)
	call add(l:regexpFragments, l:currentFragment)
    endif

    if len(l:regexpFragments) == 0
	let l:regexpFragments = ['\k\+']
    endif

    " Anchor the entire regexp at the start of a word.
    let l:regexp = '\<' . join(l:regexpFragments, '\%(\k\@!\_.\)\+')
"****D echomsg '****' l:regexp
    return l:regexp
endfunction
let s:repeatCnt = 0
function! MultiWordComplete#MultiWordComplete( findstart, base )
    if s:repeatCnt
	if a:findstart
	    return col('.') - 1
	else
	    let l:matches = []
	    call CompleteHelper#FindMatches(l:matches,
	    \   CompleteHelper#Repeat#GetPattern(s:fullText),
	    \   {'complete': s:GetCompleteOption(), 'processor': function('CompleteHelper#Repeat#Processor')}
	    \)
	    if empty(l:matches)
		call CompleteHelper#Repeat#Clear()
	    endif
	    return l:matches
	endif
    endif

    if a:findstart
	" Locate the start of the keyword that represents the initial letters.
	let l:startCol = searchpos('\k\+\%#', 'bn', line('.'))[1]
	if l:startCol == 0
	    return -1   " No base before the cursor; cancel the completion with an error message.
	endif

	if ! empty(g:MultiWordComplete_FindStartMark)
	    " Record the position of the start of the completion base to allow
	    " removal of the completion base if no matches were found.
	    let l:findstart = ingo#pos#Make4(line('.'), l:startCol)
	    call setpos(printf("'%s", g:MultiWordComplete_FindStartMark), l:findstart)
	endif

	return l:startCol - 1 " Return byte index, not column.
    elseif ! empty(a:base)
	let l:regexp = s:BuildRegexp(a:base)
	if empty(l:regexp) | throw 'ASSERT: A regexp should have been built.' | endif

	" Find keywords matching the prepared regexp. Use a case-insensitive
	" search if there is a chance that it will yield matches (i.e. if the
	" first search wasn't case-insensitive yet).
	let l:options = {'complete': s:GetCompleteOption(), 'processor': function('CompleteHelper#JoinMultiline')}
	let l:matches = []
	call CompleteHelper#FindMatches(l:matches, l:regexp, l:options)
	if empty(l:matches) && (! &ignorecase || (&ignorecase && &smartcase && a:base =~# '\u'))
	    echohl ModeMsg
	    echo '-- User defined completion (^U^N^P) -- Case-insensitive search...'
	    echohl None
	    call CompleteHelper#FindMatches(l:matches, '\c' . l:regexp, l:options)
	endif
	let s:isNoMatches = empty(l:matches)
	return l:matches
    else
	let s:isNoMatches = 1
	return []
    endif
endfunction

function! MultiWordComplete#RemoveBaseKeys()
    return (s:isNoMatches && ! empty(g:MultiWordComplete_FindStartMark) ? "\<C-e>\<C-\>\<C-o>dg`" . g:MultiWordComplete_FindStartMark : '')
endfunction
function! MultiWordComplete#Expr()
    set completefunc=MultiWordComplete#MultiWordComplete

    let s:repeatCnt = 0 " Important!
    let [s:repeatCnt, l:addedText, s:fullText] = CompleteHelper#Repeat#TestForRepeat()
    return "\<C-x>\<C-u>"
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
