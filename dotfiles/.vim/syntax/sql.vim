" TODO breaks it?
" if exists("b:current_syntax")
"     finish
" endif

let b:current_syntax = "sql"
source ~/.vim/global-syntax.vim

" syn clear
syntax sync fromstart " slow but accurate

syn case ignore
syn keyword sqlKeyword
    \ ALTER DROP SELECT UPDATE FROM CREATE TABLE INDEX TYPE DEFAULT NULL SET
    \ DOMAIN NOT INNER OUTER JOIN ON USING TYPE PRIMARY KEY AS FOREIGN
    \ start
    \ true false

syn keyword   TODO     contained TODO XXX

syn match sqlLineComment contains=todo,warning "--.*$"

syn region  sqlString      start=+'+  end=+'+

" hi clear

hi link sqlKeyword Keyword
hi link sqlLineComment Comment

hi link sqlString String
