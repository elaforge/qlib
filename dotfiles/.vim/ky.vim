" options for ky, like haskell
setl foldmethod=indent
setl ts=4 sw=4 sts=4

setl comments=:--
" replace c with t since vi's idea of comments will be backwards
setl formatoptions=troq1

setl ai
setl smarttab

vm <buffer> ,c :!cmt --<cr>

source ~/src/seq/main/ky-syntax.vim
