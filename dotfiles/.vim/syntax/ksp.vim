syntax sync fromstart " slow but accurate

" why no need he=s+6 to restrict highlight to import string?
syn keyword Keyword  declare const polyphonic if else end while select case
syn keyword Keyword  call function on

syn keyword todo     contained TODO XXX

" " trailing spaces are always bad
" syntax match warning   display "\s\+$"
" " mixed tabs and spaces
" syntax match warning   display " \+\t"
" syntax match warning   display "\t\+ "

" Backslash continues the previous line.  Vim is so bizarre.
syn region  kspBlockComment contains=todo,warning,kspBlockComment
    \ start="{"  end="}"

syn region  String      start=+"+  skip=+\\\\\|\\"+  end=+"\|$+

hi clear
hi link warning ErrorMsg

hi link kspBlockComment Comment
