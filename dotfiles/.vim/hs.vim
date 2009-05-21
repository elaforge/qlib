" options for haskell
setl foldmethod=indent

setl comments=:--
" replace c with t since vi's idea of comments will be backwards
setl formatoptions=troq1

setl ai
setl smarttab

" haskell has lots of \(...) so don't do the special \ treatment
setl cpoptions+=M

vm ,c :!cmt --<cr>
vm ,C :!uncmt --<cr>

" intentional trailing space
ino ;i import qualified 

" Make gf work on module import lines.
setl includeexpr=substitute(v:fname,'\\.','/','g')
setl suffixesadd=.hsc,.hs
