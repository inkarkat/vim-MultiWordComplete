" Test repeat of previous MultiWord completion.

let g:CompleteHelper_IsDefaultToBackwardSearch = 1
runtime tests/helpers/insert.vim
view MultiWordComplete.txt
new

call SetCompletion("\<C-x>w")
call SetCompleteExpr('MultiWordComplete#Expr')

call InsertRepeat('Viater', 0, 0, 0, 0)
call InsertRepeat('bi', 0, 1, 0, 0)
call InsertRepeat('bi', 0, 2, 0, 0)
call InsertRepeat('OWt', 0, 0, 0, 0)

call vimtest#SaveOut()
call vimtest#Quit()
