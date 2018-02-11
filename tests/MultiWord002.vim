" Test: Completion with non-alphabetic keyword anchors inside words.

runtime tests/helpers/completetest.vim
call vimtest#StartTap()
call vimtap#Plan(15)
edit MultiWordComplete.txt

set completefunc=MultiWordComplete#MultiWordComplete

call IsMatchesInIsolatedLine('ust', ['under-score: thisnot', 'under-score: two_elements', 'under-score: three_element_word', 'under-score: this_word_four_elements', 'under-score: that_has_even_five_elements'], 'ust: without underscore')
call IsMatchesInIsolatedLine('ust_', ['under-score: two_elements', 'under-score: three_element_word', 'under-score: this_word_four_elements', 'under-score: that_has_even_five_elements'], 'ust_: trailing underscore')
call IsMatchesInIsolatedLine('ust_e', ['under-score: two_elements', 'under-score: three_element_word', 'under-score: this_word_four_elements', 'under-score: that_has_even_five_elements'], 'ust_e: underscore+e anchor')
call IsMatchesInIsolatedLine('ust_f', ['under-score: this_word_four_elements', 'under-score: that_has_even_five_elements'], 'ust_f: underscore+f anchor')
call IsMatchesInIsolatedLine('ust_f_', ['under-score: this_word_four_elements', 'under-score: that_has_even_five_elements'], 'ust_f_: underscore+f anchor and trailing underscore')
call IsMatchesInIsolatedLine('ust_e_', ['under-score: that_has_even_five_elements', 'under-score: three_element_word'], 'ust_e_: underscore+e anchor and trailing underscore')
call IsMatchesInIsolatedLine('ust_w_e_', [], 'ust_w_e_: underscore+w anchor, underscore+e anchor and trailing underscore')
call IsMatchesInIsolatedLine('ust__f', ['under-score: this_word_four_elements', 'under-score: that_has_even_five_elements'], 'ust__f: underscore+underscore+f anchor')
call IsMatchesInIsolatedLine('ust_h_e_f', ['under-score: that_has_even_five_elements'], 'ust_h_e_f: pinning with multiple _? anchors')
call IsMatchesInIsolatedLine('ust___f', ['under-score: that_has_even_five_elements'], 'ust___f: pinning with multiple _ anchors')

call IsMatchesInIsolatedLine('u-st', ['score: thisnot', 'score: two_elements', 'score: three_element_word', 'score: this_word_four_elements', 'score: that_has_even_five_elements'], 'u-st isk-=-')
setlocal iskeyword+=-
call IsMatchesInIsolatedLine('u-st', ['under-score: thisnot', 'under-score: two_elements', 'under-score: three_element_word', 'under-score: this_word_four_elements', 'under-score: that_has_even_five_elements'], 'u-st isk+=- ')
call IsMatchesInIsolatedLine('u-st___f', ['under-score: that_has_even_five_elements'], 'u-st___f isk+=-')
call IsMatchesInIsolatedLine('u-s_t___f', [], 'u-s_t___f isk+=-')
call IsMatchesInIsolatedLine('u-s-t___f', [], 'u-s-t___f isk+=-')

call vimtest#Quit()
