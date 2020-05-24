let b:did_ftplugin = 1

setl ai
setl ts=4 sw=4 sts=4 et
setl foldmethod=indent

setl comments=:#
vm ,c :!cmt '\\#'<cr>
