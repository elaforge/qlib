let b:did_ftplugin = 1

setl cindent

setl foldmethod=indent
setl foldnestmax=3

setl comments=s1:/*,mb:*,ex:*/,://
vm ,c :!cmt //<cr>
