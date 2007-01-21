au!

so ~/.vim/reset.vim
au BufRead,BufNewFile *         so ~/.vim/reset.vim

" au BufRead,BufNewFile *.py      so ~/.vim/py.vim
au BufEnter *.py      so ~/.vim/py.vim
au BufRead,BufNewFile *.ptl     so ~/.vim/py.vim
au BufRead,BufNewFile *.e       so ~/.vim/e.vim
au BufRead,BufNewFile *.c       so ~/.vim/c.vim
au BufRead,BufNewFile *.h       so ~/.vim/c.vim
au BufRead,BufNewFile *.cc      so ~/.vim/cc.vim
au BufRead,BufNewFile *.cpp     so ~/.vim/cc.vim
au BufRead,BufNewFile *.cxx     so ~/.vim/cc.vim

au BufRead,BufNewFile *.scm     so ~/.vim/lisp.vim
au BufRead,BufNewFile *.lsp     so ~/.vim/lisp.vim
au BufRead,BufNewFile *.lisp    so ~/.vim/lisp.vim

au BufRead,BufNewFile *.hs      so ~/.vim/hs.vim
au BufRead,BufNewFile *.lhs     so ~/.vim/hs.vim

au BufRead,BufNewFile *.java    so ~/.vim/java.vim

au BufReadPost	*/google3/*		se ts=2 sw=2 et
au BufReadPost	*/p/*			se ts=2 sw=2 et
