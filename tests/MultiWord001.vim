" Test: Completion of multiple words. 

source ../helpers/completetest.vim
call vimtest#StartTap()
call vimtap#Plan(10) 
edit MultiWordComplete.txt

set completefunc=MultiWordComplete#MultiWordComplete

call IsMatchesInIsolatedLine('atg', ['axes to grind'], 'space-separated single match')
call IsMatchesInIsolatedLine('xtg', [], 'no match starting with x')

call IsMatchesInIsolatedLine('mpe', ['most popular editor'], 'space-separated single match')
call IsMatchesInIsolatedLine('bit', ['built-in tool', 'built-in tutorial'], 'non-keyword-separated matches')
call IsMatchesInIsolatedLine('bitf', ['built-in tool facility', 'built-in tutorial for'], 'non-keyword-separated matches')
call IsMatchesInIsolatedLine('bitfb', ['built-in tutorial for beginners'], 'non-keyword-separated match')
call IsMatchesInIsolatedLine('bitfu', ['built-in tool facility (using'], 'space and non-keyword-separated match')

call IsMatchesInIsolatedLine('ulb', ['usr/local/bin'], 'filespec match')
call IsMatchesInContext('/', '', 'ulb', ['usr/local/bin'], 'filespec match with leading /')
call IsMatchesInContext('/', '/gvim', 'ulb', ['usr/local/bin'], 'filespec match with trailing /')
" call IsMatchesInIsolatedLine('', [''], '')

call vimtest#Quit()

