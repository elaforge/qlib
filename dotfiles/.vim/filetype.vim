if exists("did_load_filetypes")
  finish
endif
let did_load_filetypes = 1

augroup filetypedetect

au BufRead,BufNewFile *.vim,vimrc setf vim

au BufRead,BufNewFile *.py      setf python
au BufRead,BufNewFile *.c,*.h   setf c
au BufRead,BufNewFile *.m,*.mm  setf c
au BufRead,BufNewFile *.cc,*.cpp,*.cxx,*.hh,*.C,*.H,*.hpp setf c
au BufRead,BufNewFile *.rs      setf rust

au BufRead,BufNewFile *.scm,*.lsp,*.lisp so setf lisp
au BufRead,BufNewFile *.clj     setf lip

au BufRead,BufNewFile *.hs      setf haskell
au BufRead,BufNewFile *.dhall   setf dhall
au BufRead,BufNewFile *.cabal   setf haskell
au BufRead,BufNewFile *.lhs,*.x,*.hsc,*.chs     setf haskell
au BufRead,BufNewFile .ghci     setf haskell
au BufRead,BufNewFile *.idr     setf idris
au BufRead,BufNewFile *.ksp     setf ksp
au BufRead,BufNewFile *.java    setf java
au BufRead,BufNewFile *.js      setf javascript
au BufRead,BufNewFile Makefile  setf makefile
au BufRead,BufNewFile *.ly,*.ily setf lilypond
au BufRead,BufNewFile *.dsp,*.dsph,*.lib setf faust
au BufRead,BufNewFile *.yml,*.yaml      setf yaml
au BufRead,BufNewFile *.journal,*.j     setf hledger
au BufRead,BufNewFile *.nix     setf nix

au BufRead,BufNewFile TODO*,todo-*,*/todo/* setf todo
au BufRead,BufNewFile *.ky      setf ky
au BufRead,BufNewFile *.tscore  setf tscore

augroup END
