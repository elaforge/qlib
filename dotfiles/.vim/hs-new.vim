function! HsModule()
    let fname = substitute(expand('%'), '\.hs$', '', '')
    return substitute(fname, '/\+', '.', 'g')
endfunction

" Only insert the module declaration if it looks like a valid module path.
if match(expand('%'), '[A-Z][^/]*\.hs$') != -1
    call append(0, 'module ' . HsModule() . ' where')
endif
