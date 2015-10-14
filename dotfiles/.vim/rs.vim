setl ai

setl comments=s1:/*,mb:*,ex:*/,://
setl foldmethod=indent
vm <buffer> ,c :!cmt //<cr>

source ~/.vim/rs-syntax.vim
