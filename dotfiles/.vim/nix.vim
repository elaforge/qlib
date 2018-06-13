setl ts=2 sw=2 sts=2
setl foldmethod=indent
set ai

setl comments=:#
vm ,c :!cmt '\\#'<cr>

" syntax

syn clear
syn region  nixString    start=+"+  skip=+\\\\\|\\"+  end=+"\|$+
" syn keyword nixKeyword   true false null
syn keyword nixKeyword   let in inherit rec or if then else with

syn match nixComment "#.*$"

hi nixString ctermfg=DarkBlue
hi nixComment cterm=bold
hi nixKeyword cterm=underline

let b:current_syntax = "nix"
