" Get the path relative to groq repo in dot syntax.
" function! GetPathPrefix()
"     " /home/elaforge/p/Groq/Groq/Test/K/Private
"     let pwd = expand('$PWD')
"     " /home/elaforge/p/Groq
"     let root = GetRepoRoot()
"     " /home/elaforge/p/Groq/
"     if pwd[:strlen(root) - 1] != root
"         echoerr('not in groq repo: ' . pwd[:strlen(root) - 1] . ' /= ' . root)
"         return ''
"     else
"         let prefix = pwd[strlen(root) + 1 :]
"         return substitute(prefix, '/', '.', 'g') . '.'
"     endif
" endfunction

setl ts=2 sw=2 sts=2

function! GetPathPrefix()
    let module = expand('%') " Groq/Infra/Bake/Hook/Metrics.hs
    let prefix = substitute(module, '/[^/]\+\.hs$', '', '')
    return substitute(prefix, '/', '.', 'g') . '.'
endfunction

function! GetRepoRoot()
    return systemlist('git rev-parse --show-toplevel')[0]
endfunction

" getline('.')
" setline(line + stuff)

" nmap ,h :call append(line('.'), GetPathPrefix())<cr>
" nmap ,h :exe 'norm i' . GetPathPrefix() . '.'<cr>

imap <c-s> <c-r>=GetPathPrefix()<cr>
