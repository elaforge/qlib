au!

so ~/.vim/reset.vim
" au BufEnter *         so ~/.vim/reset.vim
au BufRead,BufNewFile *         so ~/.vim/reset.vim

" au BufRead,BufNewFile *.py      so ~/.vim/py.vim
au BufEnter 		  *.py      so ~/.vim/py.vim
au BufEnter 		  *.ptl     so ~/.vim/py.vim
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
au BufRead,BufNewFile *.hsc     so ~/.vim/hs.vim

au BufRead,BufNewFile *.java    so ~/.vim/java.vim

au BufRead,BufNewFile TODO    se foldmethod=indent sw=2 ts=2 et

" google BUILD files are also python syntax
au BufEnter BUILD				so ~/.vim/py.vim
au BufEnter BUILD				setl ts=2 sw=2 et softtabstop=2

" googleish tiny indent
au BufEnter	*/google3/*.py		setl ts=2 sw=2 et softtabstop=2
au BufEnter */google3/*.ptl     setl ts=2 sw=2 et softtabstop=2
au BufEnter */google3/*.proto   setl ts=2 sw=2 et softtabstop=2
au BufEnter */google3/*.js      setl ts=2 sw=2 et softtabstop=2 foldmethod=indent
au BufEnter */google3/*.h       setl ts=2 sw=2 et softtabstop=2
au BufEnter */google3/*.cc      setl ts=2 sw=2 et softtabstop=2

" python with indent and folding works nicely for outline
au BufEnter TODO				so ~/.vim/py.vim
" except short indents are nice
au BufEnter TODO				se ts=2 sw=2
