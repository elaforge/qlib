" reset everything to defaults
set all&
set nocompatible " no vi compatibility
set foldignore=
" for unknown reasons the all& above doesn't do this
" colorscheme default

set ts=4 sw=4 expandtab smarttab
" set ts=2 sw=2 et
set bs=2 helpheight=99 showcmd ruler gdefault
set showmatch incsearch hlsearch
set nostartofline fileformats=unix,dos,mac
" set autowrite

set visualbell t_vb=
set comments=
set formatoptions=tcq1
set nolisp
set textwidth=0
set wrap

" eliminate annoying press enter to continue msgs with long paths
set shortmess=atI
set cmdheight=1

set wildmode=longest,list
set wildignore=*.o,*.pyc,*.pyo,*.hi,*.class
set hidden

set term=$TERM
syntax clear
" trailing spaces are always bad
syntax match ErrorMsg   display "\s\+$"
" mixed tabs and spaces
syntax match ErrorMsg   display " \+\t"
syntax match ErrorMsg   display "\t\+ "

set completeopt=preview " vim started adding an annoying menu by default
" let loaded_matchparen = 1 " stop auto paren highlighting

mapclear
mapclear!

nm ,e	:edit 
nm ,o	:buffer 
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

nm ,c V,c
nm ,C V,C

" # is default comment
vm ,c :!cmt \\#<cr>
vm ,C :!uncmt \\#<cr>


" ,d insert current date
nm ,d   :r !date<cr>
nm ,D	:r !date +\%Y-\%m-\%d<cr>

" ,w clear out trailing whitespace
" and lines ending in whitespace
nm ,w   :%s/[\t ]\+$//e<cr>

" ,p toggle paste mode
nm ,p   :se invpaste<cr>:se paste?<cr>

" switch to unexpanded tabbing
nm ,4   :se ts=4 sw=4 noet nosmarttab sts=4<cr>

" for some reason vim resets this if I put it in the .vimrc
set t_vb=
