" Test: Completion over multiple lines.

runtime tests/helpers/completetest.vim
call vimtest#StartTap()
call vimtap#Plan(3)
edit MultiWordComplete.txt

set completefunc=MultiWordComplete#MultiWordComplete

call IsMatchesInIsolatedLine('LJr', ['Linux Journal readers'], 'LJr')
call IsMatchesInIsolatedLine('attvc', ['accessed through the "vimtutor" command'], 'attvc')
call IsMatchesInIsolatedLine('atgV', ['axes to grind. Vim'], 'atgV')

call vimtest#Quit()
