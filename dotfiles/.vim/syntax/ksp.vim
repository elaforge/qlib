syntax sync fromstart " slow but accurate
source ~/.vim/global-syntax.vim

" why no need he=s+6 to restrict highlight to import string?
syn keyword Keyword  declare const polyphonic if else end while select case
syn keyword Keyword  call function on

syn keyword todo     contained TODO XXX

" Backslash continues the previous line.  Vim is so bizarre.
syn region  kspBlockComment contains=todo,warning,kspBlockComment
    \ start="{"  end="}"

syn region  String      start=+"+  skip=+\\\\\|\\"+  end=+"\|$+

hi clear
hi link warning ErrorMsg

hi link kspBlockComment Comment
