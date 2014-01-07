" Test: Keyword delimiting.

" Keep the completion base when no matches here.
let g:MultiWordComplete_FindStartMark = ''

source ../helpers/insert.vim
view MultiWordComplete.txt
new

call SetCompletion("\<C-x>w")

call Insert('Vhabitfb', 0)
call Insert('--Vhabitfb', 0)

normal! o
setlocal iskeyword+=-
call Insert('aattrv', 0)
wincmd p | setlocal iskeyword+=- | wincmd p
call Insert('aattrv', 0)
call Insert('aattrov', 0)
wincmd p | setlocal iskeyword-=- | wincmd p

normal! o
call Insert('Kts', 0)
wincmd p | setlocal iskeyword+=* | wincmd p
call Insert('Kts', 0)

normal! o
call Insert('Ktp', 0) " Only matches up to '%percent'
wincmd p | setlocal iskeyword+=% | wincmd p
call Insert('Ktp', 0) " 'p' is not at the start of the word any more, no matches.
call Insert('Kt%', -1) " '%' is the correct anchor now, but is not a keyword in this buffer, so there's no base here; a completion error.
setlocal iskeyword+=%
call Insert('Kt%p', 0) " '%' is now recognized as a keyword in both source and target buffer.

normal! o
call Insert('KtI', 0)
wincmd p | setlocal iskeyword-=_ | wincmd p
call Insert('KtI', 0)

call vimtest#SaveOut()
call vimtest#Quit()
