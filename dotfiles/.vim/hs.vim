" options for haskell

setl comments=:--
" replace c with t since vi's idea of comments will be backwards
setl formatoptions=troq1

setl ai

vm ,c :!cmt --<cr>
vm ,C :!uncmt --<cr>
