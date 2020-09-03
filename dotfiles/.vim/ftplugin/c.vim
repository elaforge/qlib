let b:did_ftplugin = 1

setl cindent
iabbr <buffer> #i #include
iabbr <buffer> #d #define

setl foldmethod=indent
setl foldnestmax=3
setl foldignore=# " ignore preprocessor

setl comments=://
vm <buffer> <LocalLeader>c :!cmt //<cr>

" setl foldmethod=marker
" setl foldmarker={,}
"
" function C_fold_level(lnum)
"       if getLine(v:lnum)[0] == '{'
"               return ">1"
"       elseif getLine(v:lnum)[0] == '}'
"               return "<1"
"       else
"               return "="
"       endif
" endfunction

nnoremap <buffer> <silent> ,h :exec ToggleHeader()<cr>

if !exists("*ToggleHeader")
    function ToggleHeader()
        let filename = expand('%')
        if match(filename, '\.cc\?$') != -1
            let filename = substitute(filename, '\.cc\?$', '.h', '')
        elseif match(filename, '\.h$') != -1
            let filename = substitute(filename, '\.h$', '.c', '')
        else
            return
        endif
        " Look for .c
        if !filereadable(filename)
            let filename = filename . 'c'
        endif
        return ":edit " . filename
    endfunction
endif
