" options for haskell

" for lhs files
set comments=:>
" replace c with t since vi's idea of comments will be backwards
set formatoptions=troq1

set ai

vm ,c :!cmt --<cr>
