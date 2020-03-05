" if exists("b:current_syntax")
"     finish
" endif

let b:current_syntax = "rust"

syntax sync fromstart " slow but accurate

syn keyword Keyword
    \ as break const continue crate dyn else enum extern false fn for if
    \ impl in let loop match mod move mut pub ref return Self self static
    \ struct super trait true type unsafe use where while

" reserved
syn keyword Keyword
    \ abstract async await become box do final macro override priv try
    \ typeof unsized virtual yield

syn region  String      start=+"+  skip=+\\\\\|\\"+  end=+"\|$+

syn match rsComment contains=todo,warning "//.*$"
syn region rsBlockComment contains=todo,warning,rsBlockComment
    \ start="/\*"  end="\*/"

syn keyword   TODO     contained TODO XXX

hi link rsComment Comment
hi link rsBlockComment Comment
