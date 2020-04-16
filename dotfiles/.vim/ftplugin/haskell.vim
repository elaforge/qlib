let b:did_ftplugin = 1

" options for haskell
setl foldmethod=indent
setl ts=4 sw=4 sts=4

setl comments=:--

setl ai
setl smarttab

" haskell has lots of \(...) so don't do the special \ treatment
setl cpoptions+=M

setl equalprg=fmt-signature\ 4\ 78

vnoremap <buffer> ,c :!cmt --<cr>
vnoremap <buffer> ,t :!string-literal --toggle-backslash<cr>
vnoremap <buffer> ,W :!string-literal --wrapped --toggle-backslash<cr>
vnoremap <buffer> ,T :!string-literal --toggle-lines<cr>

" intentional trailing space
inoremap <buffer> ;i import qualified 
inoremap <buffer> ;l {-# LANGUAGE  #-}<esc>hhhi

" Make gf work on module import lines.
setl includeexpr=substitute(v:fname,'\\.','/','g')
setl suffixesadd=.hsc,.hs

nnoremap <buffer> <silent> ,t :exec ToggleTest()<cr>
nnoremap <buffer> <silent> ,a :call FixImports()<cr>

iabbr <buffer> und undefined

if has('python')
    py import qualified_tag
    nnoremap <buffer> <silent> <c-]> :py qualified_tag.tag_word(vim)<cr>
elseif has('python3')
    py3 import qualified_tag
    nnoremap <buffer> <silent> <c-]> :py3 qualified_tag.tag_word(vim)<cr>
endif

if exists("b:did_hs_functions") || exists("*ToggleTest")
    finish
endif
let b:did_hs_functions = 1

function ToggleTest()
    let filename = expand('%')
    if match(filename, '_test\.hs$') != -1
        let filename = substitute(filename, '_test\.hs$', '.hs', '')
    elseif match(filename, '\.hsc\?$') != -1
        let filename = substitute(filename, '\.hsc\?$', '_test.hs', '')
    endif
    if filereadable(filename . 'c')
        let filename = filename . 'c'
    endif
    return ":edit " . filename
endfunction

" A ghci command can use this to load the currently edited file.
function SaveFile()
    " :load on a lowercase directory name won't work anyway.
    let filename = substitute(expand('%'), '^\.\/', '', '')
    " Either abc.hs right here, or A/B/C.hs in a subdir.
    if match(filename, '^[^/]\+\.hs$') != -1
            \ || match(filename, '[A-Z]') == 0
        call writefile([substitute(filename, "//", "/", "g")],
            \ $HOME . "/.vim/current_hs")
    endif
endfunction
au BufEnter *.hs call SaveFile()
au BufEnter *.hsc call SaveFile()

" Parse --edit output and splice in the imports.
function s:ReplaceImports(lines)
    let [start, end] = split(a:lines[0], ',')
    " Otherwise vim does string comparison.
    if end+0 > start+0
        " This stupidity is necessary because vim apparently has no way to
        " delete lines.
        let old_line = line('.')
        let old_col = col('.')
        let old_total = line('$')
        silent execute (start+1) . ',' . end . 'delete _'
        " If the import fix added or removed lines I need to take that
        " into account.  This will be wrong if the cursor was in the
        " import block.
        let new_total = line('$')
        call cursor(old_line + (new_total - old_total), old_col)
    endif
    call append(start, a:lines[1:])
endfunction

" Run the contents of the current buffer through the fix-imports cmd.  Print
" any stderr output on the status line.
function FixImports()
    let l:err = tempname()
    let l:cmd = 'fix-imports -v --edit ' . expand('%') . ' 2>' . l:err
    let l:out = systemlist(l:cmd, bufnr('%'))

    let errs = readfile(l:err)
    call delete(l:err)
    if v:shell_error == 0
        call s:ReplaceImports(l:out)
    endif
    redraw!
    if !empty(errs)
        echohl WarningMsg
        echo join(errs)
        echohl None
    endif
endfunction
