setl cindent
iabbr #i #include
iabbr #d #define

setl foldmethod=indent
setl foldnestmax=3
setl foldignore=# " ignore preprocessor

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
