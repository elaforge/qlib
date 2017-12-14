" options for kontakt's ksp
setl foldmethod=indent
setl ts=4 sw=4 sts=4

setl comments=
" replace c with t since vi's idea of comments will be backwards
setl formatoptions=troq1

setl ai
setl smarttab

syntax sync fromstart " slow but accurate

" why no need he=s+6 to restrict highlight to import string?
syn keyword kspKeyword  declare const polyphonic if end while select case
syn keyword kspKeyword  call function on

syn keyword   todo     contained TODO XXX

" trailing spaces are always bad
syntax match warning   display "\s\+$"
" mixed tabs and spaces
syntax match warning   display " \+\t"
syntax match warning   display "\t\+ "

" Backslash continues the previous line.  Vim is so bizarre.
syn region  kspBlockComment contains=todo,warning,kspBlockComment
    \ start="{"  end="}"

syn region  kspString      start=+"+  skip=+\\\\\|\\"+  end=+"\|$+

hi clear
hi link warning ErrorMsg

hi kspKeyword  cterm=underline
hi link kspBlockComment kspComment
hi kspComment cterm=bold
hi kspString ctermfg=DarkBlue

hi todo ctermbg=Cyan

let b:current_syntax = "haskell"