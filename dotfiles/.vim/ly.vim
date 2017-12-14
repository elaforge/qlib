se ai
nm gs :wa<cr>:!relily %<cr>

" lilypond has lots of \(...\) so don't do the special \ treatment
setl cpoptions+=M

setl comments=:%
vm <buffer> ,c :!cmt \\%<cr>

syn keyword   Todo     contained TODO XXX
syn match   lyComment   contains=Todo "%.*"
hi lyComment cterm=bold
