let b:current_syntax = "nix"

" syn clear
syn region  nixString    start=+"+  skip=+\\\\\|\\"+  end=+"\|$+
" syn keyword nixKeyword   true false null
syn keyword nixKeyword   let in inherit rec or if then else with

syn match nixComment "#.*$"

hi clear
hi link warning ErrorMsg
hi nixString ctermfg=DarkBlue
hi nixComment cterm=bold
hi nixKeyword cterm=underline
