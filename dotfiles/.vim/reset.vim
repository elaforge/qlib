" reset everything to defaults
set all&
set nocompatible " no vi compatibility
set foldignore=
" for unknown reasons the all& above doesn't do this
colorscheme default

set ts=4 sw=4 noet
" set ts=2 sw=2 et
set bs=2 helpheight=99 showcmd ruler gdefault shortmess=aI
set showmatch incsearch hlsearch
set nostartofline fileformats=unix,dos,mac
" set autowrite

set visualbell t_vb=
set comments=
set formatoptions=tcq1
set nolisp
set textwidth=78
set wrap

set wildmode=longest,list
set wildignore=*.o,*.pyc,*.pyo,*.ptlc,*.class
set hidden

set term=$TERM
syntax clear

mapclear
mapclear!

nm ,e	:edit 
nm ,o	:buffer 
nm ,l	:ls<cr>
nm ,u	:bdelete<cr>

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

" ,w clear out lines with only whitespace in them
nm ,w   :%s/^[\t ]\+$//<cr>``

" ,p toggle paste mode
nm ,p   :se invpaste<cr>:se paste?<cr>

" switch to unexpanded tabbing
nm ,4   :se ts=4 sw=4 noet nosmarttab sts=4<cr>

" for some reason vim resets this if I put it in the .vimrc
set t_vb=
