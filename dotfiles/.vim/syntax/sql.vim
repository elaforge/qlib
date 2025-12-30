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
    \ alter drop select update from create table index type default null set
    \ domain not inner outer join on using type primary key as foreign where
    \ and or is order by left like limit distinct group having with
    \ start insert into user delete
    \ true false

syn keyword   TODO     contained TODO XXX

syn match sqlLineComment contains=todo,warning "--.*$"

syn region  sqlString      start=+'+  end=+'+

" hi clear

hi link sqlKeyword Keyword
hi link sqlLineComment Comment

hi link sqlString String
