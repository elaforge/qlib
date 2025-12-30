let b:current_syntax = "sh"
source ~/.vim/global-syntax.vim

syn region doubleString start=+"+  skip=+\\\\\|\\"+  end=+"\|$+
syn region singleString start=+'+  end=+'\|$+
syn match comment "#.*$"

syn keyword keyword   if fi case esac do while
syn keyword keyword   export exec

" hi clear
hi link warning ErrorMsg
hi singleString ctermfg=DarkBlue
hi doubleString ctermfg=DarkBlue
hi comment cterm=bold
hi keyword cterm=underline
