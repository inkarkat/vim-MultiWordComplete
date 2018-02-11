" Test: Fallback to case-insensitive anchors. 

source ../helpers/completetest.vim
call vimtest#StartTap()
call vimtap#Plan(15) 
edit MultiWordComplete.txt

set completefunc=MultiWordComplete#MultiWordComplete

setlocal noignorecase nosmartcase
call IsMatchesInIsolatedLine('xjr', [], 'xjr')
call IsMatchesInIsolatedLine('ljr', ['like just right'], 'ljr')
call IsMatchesInIsolatedLine('LJr', ['Linux Journal readers'], 'LJr')
call IsMatchesInIsolatedLine('lJr', ['like just right', 'Linux Journal readers'], 'lJr fallback')
call IsMatchesInIsolatedLine('LJR', ['like just right', 'Linux Journal readers'], 'LJR fallback')

setlocal ignorecase nosmartcase
call IsMatchesInIsolatedLine('xjr', [], 'xjr case-insensitive')
call IsMatchesInIsolatedLine('ljr', ['like just right', 'Linux Journal readers'], 'ljr case-insensitive')
call IsMatchesInIsolatedLine('LJr', ['like just right', 'Linux Journal readers'], 'LJr case-insensitive')
call IsMatchesInIsolatedLine('lJr', ['like just right', 'Linux Journal readers'], 'lJr case-insensitive')
call IsMatchesInIsolatedLine('LJR', ['like just right', 'Linux Journal readers'], 'LJR case-insensitive')

setlocal ignorecase smartcase
call IsMatchesInIsolatedLine('xjr', [], 'xjr smartcase') " No need to do the case-insensitive fallback search here. 
call IsMatchesInIsolatedLine('ljr', ['like just right', 'Linux Journal readers'], 'ljr smartcase')
call IsMatchesInIsolatedLine('LJr', ['Linux Journal readers'], 'LJr smartcase')
call IsMatchesInIsolatedLine('lJr', ['like just right', 'Linux Journal readers'], 'lJr smartcase')
call IsMatchesInIsolatedLine('LJR', ['like just right', 'Linux Journal readers'], 'LJR smartcase')

call vimtest#Quit()

