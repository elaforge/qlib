" if exists("b:current_syntax")
"     finish
" endif

let b:current_syntax = "rust"
source ~/.vim/global-syntax.vim

syntax sync fromstart " slow but accurate

syn keyword Keyword
    \ as async await break const continue crate dyn else enum extern
    \ false fn for if impl in let loop match mod move mut pub ref
    \ return Self self static struct super trait true type union unsafe
    \ use where while

" reserved
syn keyword Keyword
    \ abstract become box do final gen macro override priv try typeof
    \ unsized virtual yield

syn region  String      start=+"+  skip=+\\\\\|\\"+  end=+"\|$+

syn match rsComment contains=todo,warning "//.*$"
syn region rsBlockComment contains=todo,warning,rsBlockComment
    \ start="/\*"  end="\*/"

syn keyword   TODO     contained TODO XXX

hi link rsComment Comment
hi link rsBlockComment Comment
