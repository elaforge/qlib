let b:did_ftplugin = 1

setl ai
setl sw=2
setl foldmethod=indent

setl comments=:#
vm ,c :!cmt '\\#'<cr>
