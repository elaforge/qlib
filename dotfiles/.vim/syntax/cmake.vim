let b:current_syntax = "cmake"
source ~/.vim/global-syntax.vim

" syn clear
syn region  string    start=+"+  skip=+\\\\\|\\"+  end=+"\|$+
syn keyword keyword   set include find_package
syn match comment "#.*$"

" hi clear
hi string ctermfg=DarkBlue
hi comment cterm=bold
hi keyword cterm=underline
