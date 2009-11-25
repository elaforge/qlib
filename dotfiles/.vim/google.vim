" set google things

" switch on extensions: py, proto, js, h, cc?

setl ts=2 sw=2 et softtabstop=2

if @% =~ ".*/BUILD"
    so ~/.vim/py.vim
endif
