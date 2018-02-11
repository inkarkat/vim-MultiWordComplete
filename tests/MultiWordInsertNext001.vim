" Test: Insertion of next MultiWord words.

let g:CompleteHelper_IsDefaultToBackwardSearch = 0
runtime tests/helpers/insert.vim
view MultiWordComplete.txt
new

call SetCompletion("\<C-x>w")

call Insert('Viater', 0)
call Insert('i1ftA', 0)
normal! o
call Insert('bit', 1)
call Insert('bit', 2)
normal! o
call Insert('/ubv', 1)
call Insert('/ubv', 2)
normal! o
call Insert('ufb64e', 0)
call Insert('nmi4', 0)
normal! o||
normal! ^
call Insert('trov', 0)

call vimtest#SaveOut()
call vimtest#Quit()
