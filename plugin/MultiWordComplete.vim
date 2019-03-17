" MultiWordComplete.vim Insert mode completion that completes a sequence of words based on anchor characters for each word.
"
" DEPENDENCIES:
"   - Requires Vim 7.0 or higher.
"
" Copyright: (C) 2010-2019 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>

" Avoid installing twice or when in unsupported Vim version.
if exists('g:loaded_MultiWordComplete') || (v:version < 700)
    finish
endif
let g:loaded_MultiWordComplete = 1

"- configuration ---------------------------------------------------------------

if ! exists('g:MultiWordComplete_FindStartMark')
    " To avoid clobbering user-set marks, we use the obscure "last exit point of
    " buffer" mark.
    " Setting of mark '" is only supported since Vim 7.2; use last jump mark ''
    " for Vim 7.0 and 7.1.
    let g:MultiWordComplete_FindStartMark = (v:version < 702 ? "'" : '"')
endif


"- mappings --------------------------------------------------------------------

inoremap <silent> <Plug>(MultiWordPostComplete) <C-r>=MultiWordComplete#RemoveBaseKeys()<CR>
inoremap <silent> <expr> <Plug>(MultiWordComplete) MultiWordComplete#Expr()
if ! hasmapto('<Plug>(MultiWordComplete)', 'i')
    execute 'imap <C-x>w <Plug>(MultiWordComplete)' . (empty(g:MultiWordComplete_FindStartMark) ? '' : '<Plug>(MultiWordPostComplete)')
endif

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
