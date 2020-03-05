let b:did_ftplugin = 1

setl ai

setl comments=://
setl foldmethod=indent
vm <buffer> ,c :!cmt //<cr>
