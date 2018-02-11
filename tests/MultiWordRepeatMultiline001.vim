" Test repeat of MultiWord completion across lines.

runtime tests/helpers/insert.vim
view MultiWordComplete.txt
new

call SetCompletion("\<C-x>w")
call SetCompleteExpr('MultiWordComplete#Expr')

call InsertRepeat('cpo', 0, 0, 0, 0, 0)
call InsertRepeat('BMi', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)

call vimtest#SaveOut()
call vimtest#Quit()
