let b:did_ftplugin = 1

setl ai

setl comments=s1:/*,mb:*,ex:*/,://
setl foldmethod=indent
vm <buffer> ,c :!cmt //<cr>
