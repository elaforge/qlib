setl cindent
iabbr <buffer> #i #include
iabbr <buffer> #d #define

setl foldmethod=indent
setl foldnestmax=3
setl foldignore=# " ignore preprocessor

setl comments=s1:/*,mb:*,ex:*/,://
vm <buffer> ,c :!cmt //<cr>

" setl foldmethod=marker
" setl foldmarker={,}
" 
" function C_fold_level(lnum)
" 	if getLine(v:lnum)[0] == '{'
" 		return ">1"
" 	elseif getLine(v:lnum)[0] == '}'
" 		return "<1"
" 	else
" 		return "="
" 	endif
" endfunction

nm <silent> ,h :exec ToggleHeader()<cr>

if exists("*ToggleHeader")
    finish
endif

function ToggleHeader()
    let filename = expand('%')
    if match(filename, '\.cc\?$') != -1
        let filename = substitute(filename, '\.cc\?$', '.h', '')
    elseif match(filename, '\.h$') != -1
        let filename = substitute(filename, '\.h$', '.c', '')
    endif
    " Look for .cc
    if filereadable(filename . 'c')
        let filename = filename . 'c'
    endif
    return ":edit " . filename
endfunction
