if $host == "archie"
    " I don't know why arrow keys are broken on the mac terminal.
    " set t_ku=[A
    " set t_kd=[B
    " set t_kr=[C
    " set t_kl=[D
endif

au!

au BufRead,BufNewFile *         so ~/.vim/global.vim

au BufRead,BufNewFile *.py      so ~/.vim/py.vim
au BufRead,BufNewFile *.e       so ~/.vim/e.vim
au BufRead,BufNewFile *.c       so ~/.vim/c.vim
au BufRead,BufNewFile *.h       so ~/.vim/c.vim
au BufRead,BufNewFile *.m       so ~/.vim/c.vim
au BufRead,BufNewFile *.cc      so ~/.vim/c.vim
au BufRead,BufNewFile *.mm      so ~/.vim/c.vim
au BufRead,BufNewFile *.m       so ~/.vim/c.vim
au BufRead,BufNewFile *.cpp     so ~/.vim/c.vim
au BufRead,BufNewFile *.cxx     so ~/.vim/c.vim

au BufRead,BufNewFile *.scm     so ~/.vim/lisp.vim
au BufRead,BufNewFile *.lsp     so ~/.vim/lisp.vim
au BufRead,BufNewFile *.lisp    so ~/.vim/lisp.vim

au BufRead,BufNewFile *.hs      so ~/.vim/hs.vim
au BufRead,BufNewFile *.lhs     so ~/.vim/hs.vim
au BufRead,BufNewFile *.hsc     so ~/.vim/hs.vim

au BufRead,BufNewFile *.java    so ~/.vim/java.vim
au BufRead,BufNewFile *.xml     so ~/.vim/xml.vim


au BufEnter TODO                so ~/.vim/todo.vim
au BufEnter *_todo              so ~/.vim/todo.vim

au BufRead,BufNewFile Makefile  setl noexpandtab sw=4 ts=4

au BufRead,BufNewFile */google3/* so ~/.vim/google.vim

" reset everything to defaults
set all&
syntax clear

set completeopt=preview " vim started adding an annoying menu by default
" let loaded_matchparen = 1 " stop auto paren highlighting

set nocompatible " no vi compatibility
set foldignore=
set foldopen=block,hor,insert,jump,mark,percent,quickfix,search,tag,undo

set ts=8 sw=4 expandtab smarttab
set bs=2 helpheight=99 showcmd ruler gdefault
set showmatch incsearch hlsearch
set nostartofline fileformats=unix,dos,mac
set cpoptions= " don't need no annoying vi compatibility

" only one indent in parens, but I actually like the 2*
" set cinoptions=(4
" c indent continuation lines are just a single indent + 0 spaces
" set cinoptions=+0

set visualbell t_vb=
set comments=

" wrap text, comments, format comments
set formatoptions=tcroq
" don't break lines already past tw, break and join chinese sensibly
set formatoptions+=lmM

set nolisp
set textwidth=0
set wrap

" eliminate annoying press enter to continue msgs with long paths
set shortmess=atI
set cmdheight=1

set wildmode=longest,list
set wildignore=*.o,*.pyc,*.pyo,*.hi,*.hi-boot,*.o-boot,*.class
set hidden

mapclear
mapclear!

nm ,e	:edit 
nm ;e   :edit <C-R>=expand("%:h") . "/" <CR>
nm ,o	:buffer 
nm ;o   :buffer <C-R>=expand("%:h") . "/" <CR>
nm ,l	:ls<cr>
nm ,u	:bdelete<cr>

" fix traditional vi annoyances
nm Y	y$
nm ''	``

nmap <down> <c-e>
nmap <up> <c-y>

ino <c-f>   <c-x><c-f>
    " complete filenames

nm gqp  gqap
nm gz   :wa<cr>

nm <silent> ,s :nohlsearch<cr>:match<cr>
nm <silent> ,n :exe 'match IncSearch "\<' . expand("<cword>") . '\>"'<cr>

nm ,c V,c

" # is default comment
vm ,c :!cmt '\\#'<cr>


" ,d insert current date
nm <silent> ,d   :r !date<cr>
nm <silent> ,D	:r !date +\%Y-\%m-\%d<cr>
nm <silent> ,t   :r !date +\%H:\%M:\%S<cr>

" ,w clear out trailing whitespace
" and lines ending in whitespace
nm <silent> ,w   :%s/[\t ]\+$//e<cr>

" ,p toggle paste mode
nm ,p   :se invpaste<cr>:se paste?<cr>

" switch to unexpanded tabbing
nm ,4   :se ts=4 sw=4 noet nosmarttab sts=4<cr>

so ~/.vim/global.vim
so ~/.vim/plugin/*.vim

if $domain =~ '.*\.corp\.google\.com'
    " gtags script doesn't like to be called twice, so I can't call from
    " google.vim
    source /home/build/nonconf/google3/tools/tags/gtags.vim
    nmap <silent> <c-j> :exec 'Gtag ' . expand('<cword>')<cr>
    " :Gtlistcallers to search for callers
endif

if has('python')
    py import sys, os, vim
    py sys.path.insert(0, os.environ['HOME'] + '/.vim/py')
    py import swapwords

    nm <silent> <c-s> :py swapwords.vim_swap_word(vim)<cr>
    nm <silent> <c-n> :py swapwords.vim_swap_delim(vim)<cr>
endif
