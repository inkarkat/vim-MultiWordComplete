" Test: Completion with number anchors. 

source ../helpers/completetest.vim
call vimtest#StartTap()
call vimtap#Plan(12) 
edit MultiWordComplete.txt

set completefunc=MultiWordComplete#MultiWordComplete

call IsMatchesInIsolatedLine('_', ['_Solaris_32', '_Solaris_64', '_WINNT'], '_: only underscore')
call IsMatchesInIsolatedLine('_W', ['_WINNT'], '_W: leading underscore')
call IsMatchesInIsolatedLine('_S_3', ['_Solaris_32'], '_S_3: leading underscore')
call IsMatchesInIsolatedLine('_S_32', ['_Solaris_32'], '_S_32: leading underscore')

call IsMatchesInIsolatedLine('b64', ['base64'], 'b64')
call IsMatchesInIsolatedLine('F2', ['Foobar 2000', 'Foo 2001'], 'F2 can match separate number')
call IsMatchesInIsolatedLine('F2e', ['Foo 2001 edition'], 'F2e e anchor matches separate word')
call IsMatchesInIsolatedLine('a3p', ['abc123password'], 'a3p p anchor matches directly after 3')
call IsMatchesInIsolatedLine('a1p', [], 'a1p p anchor does not match directly after 1')
call IsMatchesInIsolatedLine('F21', ['Foo 2001'], 'F21 can match separate 2001')
call IsMatchesInIsolatedLine('4', ['4Chan'], '4 matches start of word')
call IsMatchesInIsolatedLine('i4', ['in 4Chan'], 'i4: 4 matches start of word')

call vimtest#Quit()

