" Test: Removal of MultiWord base when no match. 

let g:MultiWordComplete_FindStartMark = 'z'
source ../helpers/insert.vim
view MultiWordComplete.txt
new

call SetCompletion("\<C-x>w")

call Insert('Viate', 0)
call Insert('rbBM', 0)
normal! o
call Insert('Viaks', 0)
call Insert('no match:Viaks', 0)

let g:MultiWordComplete_FindStartMark = ''
normal! o- no findstart mark -
normal! o
call Insert('Viaks', 0)
call Insert('no match:Viaks', 0)

call vimtest#SaveOut()
call vimtest#Quit()

