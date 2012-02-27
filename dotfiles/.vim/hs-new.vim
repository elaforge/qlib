function! HsModule()
    let fname = substitute(expand('%'), '\.hs$', '', '')
    return substitute(fname, '/\+', '.', 'g')
endfunction

call append(0, 'module ' . HsModule() . ' where')
