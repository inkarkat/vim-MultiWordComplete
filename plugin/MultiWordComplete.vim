" MultiWordComplete.vim Insert mode completion that completes a sequence of
" words based on anchor characters for each word. 
"
" DESCRIPTION:
"   The built-in insert mode completion completes single words, and one can copy
"   the words following the previous expansion one-by-one. (But that is
"   cumbersome and doesn't scale when there are many alternatives.) 
"   This plugin offers completion of sequences of words, i.e. everything
"   separated by whitespace, non-keyword characters or the start / end of line,
"   based on the typed first letter of each word. With this, one can quickly
"   complete entire phrases; for example, "imc" completes to "insert mode
"   completion", and "/ulb" completes to "/usr/local/bin". 
"
" USAGE:
" i_CTRL-X_w		Find matches for multiple words which begin with the
"			typed letters in front of the cursor. Unless
"			'ignorecase' is set, a case-sensitive match is tried
"			first. 
"			Non-alphabetic keyword characters (e.g. "_") can be
"			inserted into the completion base to force inclusion of
"			these, e.g. both "mf" and "mf_b" complete to 
"			"my foo_bar", but the latter excludes "my foobar" and 
"			"my foo_quux". 
"			An alphabetic anchor following a non-alphabetic anchor
"			must match immediately after the non-alphabetic letter,
"			not in the next word. Thus, parse the base "mf_b" as
"			"m", "f", "_b". 
"			
"   In insert mode, type all initial letters of the requested phrase, and invoke
"   the multi-word completion via CTRL-W w. You can then search forward and
"   backward via CTRL-N / CTRL-P, as usual. 
"
" INSTALLATION:
" DEPENDENCIES:
"   - CompleteHelper.vim autoload script. 
"
" CONFIGURATION:
"   Analoguous to the 'complete' option, you can specify which buffers will be
"   scanned for completion candidates. Currently, only '.' (current buffer) and
"   'w' (buffers from other windows) are supported. >
"	let g:MultiWordComplete_complete string = '.,w'
"   The global setting can be overridden for a particular buffer
"   (b:MultiWordComplete_complete). 
"   
" INTEGRATION:
" LIMITATIONS:
" ASSUMPTIONS:
" KNOWN PROBLEMS:
" TODO:
"   - Allow '.' wildcard for a single and '*' for multiple words. 
"   - Case?
"   - When whitespace before base, include trailing non-keywords in matches,
"     When non-keywords before base, stop at last keyword character in matches? 
"
" Copyright: (C) 2010 by Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'. 
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS 
"	001	26-Feb-2010	file creation

" Avoid installing twice or when in unsupported Vim version. 
if exists('g:loaded_MultiWordComplete') || (v:version < 700)
    finish
endif
let g:loaded_MultiWordComplete = 1

if ! exists('g:MultiWordComplete_complete')
    let g:MultiWordComplete_complete = '.,w'
endif

function! s:GetCompleteOption()
    return (exists('b:MultiWordComplete_complete') ? b:MultiWordComplete_complete : g:MultiWordComplete_complete)
endfunction

function! s:IsAlpha( expr )
    return (a:expr =~# '^\a\+$')
endfunction
function! s:BuildRegexp( base )
    " Each alphabetic character is an anchor for the beginning of a word. 
    " All other (keyword) characters must just match at that position. 
    let l:anchors = map(split(a:base, '\zs'), 'escape(v:val, "\\")')
    let l:alphabeticAnchors = filter(copy(l:anchors), 's:IsAlpha(v:val)')

    " Assemble all regexp fragments together to build the full regexp. 
    " There is a strict regexp which is tried first and a relaxed regexp to fall
    " back on. 
    let l:regexpFragments = []
    let l:currentFragment = ''
    for l:i in range(len(l:anchors))
	let l:anchor = l:anchors[l:i]
	if s:IsAlpha(l:anchor)
	    " If an anchor is alphabetic, match a word fragment that starts with
	    " the anchor. 
	    if l:i > 0 && s:IsAlpha(get(l:anchors, l:i- 1, ''))
		call add(l:regexpFragments, l:currentFragment)
		let l:currentFragment = ''
	    endif
	    let l:currentFragment .= l:anchor . '\k*'
	else
	    " If an anchor is a keyword character, just match that character in
	    " case it is followed by an alphabetic anchor. 
	    let l:currentFragment .= l:anchor . (s:IsAlpha(get(l:anchors, l:i + 1, '')) ? '' : '\k*')
	endif
    endfor
    if ! empty(l:currentFragment)
	call add(l:regexpFragments, l:currentFragment)
    endif

    if len(l:regexpFragments) == 0
	let l:regexpFragments = ['\k\+']
    endif

    " Anchor the entire regexp at the start of a word. 
    let l:regexp = '\<' . join(l:regexpFragments, '\%(\k\@!\_.\)\+')
echomsg '****' l:regexp
    return [l:regexp, '']
endfunction
function! MultiWordComplete#MultiWordComplete( findstart, base )
    if a:findstart
	" Locate the start of the keyword that represents the initial letters. 
	let l:startCol = searchpos('\k*\%#', 'bn', line('.'))[1]
	if l:startCol == 0
	    let l:startCol = col('.')
	endif
	return l:startCol - 1 " Return byte index, not column. 
    else
	let [l:strictRegexp, l:relaxedRegexp] = s:BuildRegexp(a:base)
"****D let [g:sr, g:rr] = [l:strictRegexp, l:relaxedRegexp]
	if empty(l:strictRegexp) | throw 'ASSERT: At least a strict regexp should have been built.' | endif

	" Find keywords matching the prepared regexp. Use the relaxed regexp
	" when the strict one doesn't yield any matches. 
	let l:matches = []
"****D echomsg '****strict ' l:strictRegexp
	call CompleteHelper#FindMatches( l:matches, l:strictRegexp, {'complete': s:GetCompleteOption()} )
	if empty(l:matches) && ! empty(l:relaxedRegexp)
"****D echomsg '****relaxed' l:relaxedRegexp
	    echohl ModeMsg
	    echo '-- User defined completion (^U^N^P) -- Relaxed search...'
	    echohl None
	    call CompleteHelper#FindMatches( l:matches, l:relaxedRegexp, {'complete': s:GetCompleteOption()} )
	endif
	return l:matches
    endif
endfunction

function! s:MultiWordCompleteExpr()
    set completefunc=MultiWordComplete#MultiWordComplete
    return "\<C-x>\<C-u>"
endfunction
inoremap <script> <expr> <Plug>MultiWordComplete <SID>MultiWordCompleteExpr()
if ! hasmapto('<Plug>MultiWordComplete', 'i')
    imap <C-x>w <Plug>MultiWordComplete
endif

" vim: set sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
