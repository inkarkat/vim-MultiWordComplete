" Test: Completion with non-alphabetic keyword anchors for separate words.

runtime tests/helpers/completetest.vim
call vimtest#StartTap()
call vimtap#Plan(18)
edit MultiWordComplete.txt

set completefunc=MultiWordComplete#MultiWordComplete

call IsMatchesInIsolatedLine('_', ['_Solaris_32', '_Solaris_64', '_WINNT'], '_: only underscore')
call IsMatchesInIsolatedLine('P_', ['Platforms: _WINNT'], 'P_: underscore matches separate word')
call IsMatchesInIsolatedLine('P__', ['Platforms: _WINNT _Solaris_32'], 'P__: underscore matches 2 separate words')
" Because of the greedy matching, the longer, four-word string is returned.
call IsMatchesInIsolatedLine('P___', ['Platforms: _WINNT _Solaris_32 _Solaris_64'], 'P___: underscore matches 3 separate words')
" ...unless one restricts the match via an additional non-alphabetic anchor (here: "3")
call IsMatchesInIsolatedLine('P___3', ['Platforms: _WINNT _Solaris_32'], 'P___3: underscore matches 2 separate words')

call IsMatchesInIsolatedLine('Ktp', ['Keyword-test: %percent'], 'Ktp')
call IsMatchesInIsolatedLine('Ktps', ['Keyword-test: %percent%strange'], 'Ktps')
call IsMatchesInIsolatedLine('Ktpss', ['Keyword-test: %percent%strange%separator'], 'Ktpss')
setlocal iskeyword+=%
call IsMatchesInIsolatedLine('Ktp', [], 'Ktp with isk+=%')
call IsMatchesInIsolatedLine('Kt%', ['Keyword-test: %percent%strange%separator%'], 'Kt% with isk+=%')
call IsMatchesInIsolatedLine('Kt%p', ['Keyword-test: %percent%strange%separator%'], 'Kt%p with isk+=%')
call IsMatchesInIsolatedLine('Kt%%%', ['Keyword-test: %percent%strange%separator%'], 'Kt%%% with isk+=%')
call IsMatchesInIsolatedLine('Kt%p%s', ['Keyword-test: %percent%strange%separator%'], 'Kt%p%s with isk+=%')
call IsMatchesInIsolatedLine('Kt%p%s%s', ['Keyword-test: %percent%strange%separator%'], 'Kt%p%s%s with isk+=%')

call IsMatchesInIsolatedLine('Kth', ['Keyword-test: \here'], 'Kth')
setlocal iskeyword+=\\
call IsMatchesInIsolatedLine('Kt\', ['Keyword-test: \here\document\'], 'Kt\ with isk+=\\')
call IsMatchesInIsolatedLine('Kt\\\', ['Keyword-test: \here\document\'], 'Kt\\\ with isk+=\\')
call IsMatchesInIsolatedLine('Kt\h\d', ['Keyword-test: \here\document\'], 'Kt\h\d with isk+=\\')

call vimtest#Quit()
