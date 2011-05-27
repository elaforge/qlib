" set google things

" switch on extensions: py, proto, js, h, cc?

setl ts=2 sw=2 et softtabstop=2

" gtags script doesn't like to be called twice, so I can't call from
" google.vim
source ~/.vim/gtags.vim
nmap <silent> <c-j> :exec 'Gtag ' . expand('<cword>')<cr>
" :Gtlistcallers to search for callers

" Avoid NFS annoyances.
silent !mkdir -p /tmp/vim_swap
set dir=/tmp/vim_swap

au BufRead,BufNewFile BUILD     so ~/.vim/py.vim

" big tabs for g4 cl descriptions
au BufRead,BufNewFile /tmp/*4-change.txt        set ts=8 noet
au BufRead,BufNewFile /tmp/*4-mail.txt          set ts=8 noet
