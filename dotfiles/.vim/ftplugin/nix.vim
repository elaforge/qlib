let b:did_ftplugin = 1

setl ts=2 sw=2 sts=2
setl foldmethod=indent
set ai

setl comments=:#
vm ,c :!cmt '\\#'<cr>
