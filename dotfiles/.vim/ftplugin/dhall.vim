let b:did_ftplugin = 1

" options for haskell
setl foldmethod=indent
setl ts=4 sw=4 sts=4

setl comments=:--
vnoremap <buffer> ,c :!cmt --<cr>

setl ai
setl smarttab

" haskell has lots of \(...) so don't do the special \ treatment
setl cpoptions+=M
