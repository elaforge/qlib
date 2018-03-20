let maplocalleader = ","

" clear all filetypes autocmds
augroup filetypes
autocmd!

au BufRead,BufNewFile *         so ~/.vim/global.vim

au BufRead,BufNewFile *.py      so ~/.vim/py.vim
au BufRead,BufNewFile wscript   so ~/.vim/py.vim
au BufRead,BufNewFile *.e       so ~/.vim/e.vim
au BufRead,BufNewFile *.c       so ~/.vim/c.vim
au BufRead,BufNewFile *.h       so ~/.vim/c.vim
au BufRead,BufNewFile *.m       so ~/.vim/c.vim
au BufRead,BufNewFile *.cc      so ~/.vim/c.vim
au BufRead,BufNewFile *.mm      so ~/.vim/c.vim
au BufRead,BufNewFile *.m       so ~/.vim/c.vim
au BufRead,BufNewFile *.cpp     so ~/.vim/c.vim
au BufRead,BufNewFile *.cxx     so ~/.vim/c.vim
au BufRead,BufNewFile *.rs      so ~/.vim/rs.vim

au BufRead,BufNewFile *.scm     so ~/.vim/lisp.vim
au BufRead,BufNewFile *.lsp     so ~/.vim/lisp.vim
au BufRead,BufNewFile *.lisp    so ~/.vim/lisp.vim
au BufRead,BufNewFile *.clj     so ~/.vim/lisp.vim

" haskell
au BufRead,BufNewFile *.hs      so ~/.vim/hs.vim
au BufRead,BufNewFile *.cabal   so ~/.vim/hs.vim
au BufRead,BufNewFile *.x       so ~/.vim/hs.vim " alex
au BufRead,BufNewFile *.lhs     so ~/.vim/hs.vim
au BufRead,BufNewFile *.hsc     so ~/.vim/hs.vim
au BufRead,BufNewFile *.chs     so ~/.vim/hs.vim
au BufRead,BufNewFile .ghci     so ~/.vim/hs.vim
" GHC profile output.
au BufRead,BufNewFile *.prof    set shiftwidth=1 | set foldmethod=indent | set foldnestmax=20
au BufNewFile *.hs              so ~/.vim/hs-new.vim
au BufNewFile *.hsc             so ~/.vim/hs-new.vim
" close enough
au BufRead,BufNewFile *.idr     so ~/.vim/idr.vim

au BufRead,BufNewFile *.ky      so ~/.vim/ky.vim
au BufRead,BufNewFile *.ksp     so ~/.vim/ksp.vim

au BufRead,BufNewFile *.java    so ~/.vim/java.vim
" close enough...
au BufRead,BufNewFile *.js      so ~/.vim/java.vim
au BufRead,BufNewFile *.xml     so ~/.vim/xml.vim
au BufRead,BufNewFile *.php     setl ts=2 sw=2 et softtabstop=2 ai

au BufEnter TODO*               so ~/.vim/todo.vim
au BufEnter todo-*              so ~/.vim/todo.vim
au BufEnter */todo/*            so ~/.vim/todo.vim

au BufRead,BufNewFile Makefile  so ~/.vim/makefile.vim

au BufRead,BufNewFile *.ly      so ~/.vim/ly.vim
au BufRead,BufNewFile *.ily     so ~/.vim/ly.vim

au BufRead,BufNewFile *.dsp     so ~/.vim/faust.vim

au BufRead,BufNewFile *.yml     so ~/.vim/yaml.vim

augroup END

" reset everything to defaults
set all&
syntax clear

set noloadplugins " don't read crap from $VIM/plugins
set nocompatible " no vi compatibility, matchparen requires this
runtime plugin/matchparen.vim " wait, except I like this one

set exrc " read .vimrc from the current directory too
set completeopt=preview " vim started adding an annoying menu by default

" Key mappings timeout after 1 sec, key codes after .1 sec.
set timeoutlen=1000 ttimeoutlen=100

set foldignore=
" Vim is buggy and won't open a fold if a search jumps into it, even if
" 'search' is in foldopen.  'all' will make it open, but is otherwise useless
" because it won't let you close a fold at all.
set foldopen=block,hor,insert,jump,mark,percent,quickfix,search,tag,undo

set ts=8 sw=4 expandtab smarttab
set bs=2 helpheight=99 showcmd ruler gdefault
set showmatch incsearch hlsearch
set nostartofline fileformats=unix,dos,mac

" or full,list
set wildmode=longest,list

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

set notagrelative " don't look for tags relative to the edited file
" files and tab completion are case sensitive, even on OS X
set nofileignorecase

mapclear
mapclear!

" vim is buggy and doesn't open folds even though its set to
" nm <silent> n /<cr>
" nm <silent> N ?<cr>

nmap ,e   :edit 
nmap ;e   :edit <C-R>=expand("%:h") . "/" <CR>
nmap ,o   :buffer 
nmap ;o   :buffer <C-R>=expand("%:h") . "/" <CR>
nmap ,l   :ls<cr>
nmap ,u   :bdelete<cr>

" I never actually want to look up a man page.
nm K k
vm K k

" fix traditional vi annoyances
nmap Y  y$
nmap '' ``
" Get rid of useless control-space behaviour.
imap <Nul> <Space>

nmap <down> <c-e>
nmap <up> <c-y>
nmap <c-@> @@

" complete filenames
inoremap <c-f>   <c-x><c-f>
" complete tags
inoremap <c-]> <c-x><c-]>


nm gqp  gqap
nm gz   :wa<cr>
nm Q gq

" nm <silent> ,s :nohlsearch<cr>:match<cr>
nm <silent> ,s :nohlsearch<cr>
" nm <silent> ,n :exe 'match IncSearch "\<' . expand("<cword>") . '\>"'<cr>
nm <silent> ,n :let @/='<C-R><C-W>'<CR>:set hls<CR>
" nm <Leader>* :let @/='\<'.expand('<cword>').'\>'<CR>


nm ,c V,c

" # is default comment
vm ,c :!cmt '\#'<cr>


" ,d insert current date
nm <silent> ,d  :r !date +\%Y-\%m-\%d<cr>

" clear out trailing whitespace and lines ending in whitespace
nm <silent> ,w   :%s/[\t ]\+$//e<cr>

" ,p toggle paste mode
nm ,p   :se invpaste<cr>:se paste?<cr>

nm <c-j> :next<cr>

source ~/.vim/global.vim

if has('python')
    py import sys, os, vim
    py sys.path.insert(0, os.environ['HOME'] + '/.vim/py')
    py import swapwords

    nm <silent> <c-s> :py swapwords.vim_swap_word(vim)<cr>
    nm <silent> <c-n> :py swapwords.vim_swap_delim(vim)<cr>
endif

source ~/.vim/bundle/vim-surround/plugin/surround.vim
" set runtimepath^=~/.vim/bundle/vim-surround
" set runtimepath^=~/.vim/bundle/ctrlp.vim

" Disable for now.
" let g:loaded_ctrlp = 1

" let g:ctrlp_map = '<c-p>'
" let g:ctrlp_switch_buffer = 'Et'
" let g:ctrlp_custom_ignore = '\v(_darcs|\.git)$'
" runtime plugin/ctrlp.vim
