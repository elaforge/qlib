let b:did_ftplugin = 1

setl foldmethod=indent
setl ts=2 sw=2 sts=2

setl comments=:--
vnoremap <buffer> ,c :!cmt --<cr>
