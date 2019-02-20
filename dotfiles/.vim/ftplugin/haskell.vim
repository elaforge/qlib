let b:did_ftplugin = 1

" options for haskell
setl foldmethod=indent
setl ts=4 sw=4 sts=4

setl comments=:--
" replace c with t since vi's idea of comments will be backwards
setl formatoptions=troq1

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
inoremap <buffer> ;l {-# LANGUAGE #-}<esc>hhhi 

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
    if match(expand('%'), '^[^/]\+\.hs$') != -1
            \ || match(expand('%'), '[A-Z]') == 0
        call writefile([substitute(expand('%'), "//", "/", "g")],
            \ $HOME . "/.vim/current_hs")
    endif
endfunction
au BufEnter *.hs call SaveFile()
au BufEnter *.hsc call SaveFile()

" Run the contents of the current buffer through the fix-imports cmd.  Print
" any stderr output on the status line.
" Remove 'a' from cpoptions if you don't want this to mess up #.
function FixImports()
    let out = tempname()
    let err = tempname()
    let tmp = tempname()
    " Using a tmp file means I don't have to save the buffer, which the user
    " didn't ask for.
    silent execute 'write' tmp
    silent execute '!fix-imports -v' expand('%') '<' tmp '>' out '2>' err
    let errs = readfile(err)
    if v:shell_error == 0
        " Don't replace the buffer if there's no change, this way I won't
        " mess up fold and undo state.
        call system('cmp -s ' . tmp . ' ' . out)
        if v:shell_error != 0
            " Is there an easier way to replace the buffer with a file?
            let old_line = line('.')
            let old_col = col('.')
            let old_total = line('$')
            %d
            execute 'silent :read' out
            0d
            let new_total = line('$')
            " If the import fix added or removed lines I need to take that
            " into account.  This will be wrong if the cursor was above the
            " import block.
            call cursor(old_line + (new_total - old_total), old_col)
            " The reload will forget fold state.  It was open, right?
            if foldclosed('.') != -1
                execute 'normal zO'
            endif
        endif
    endif
    call delete(out)
    call delete(err)
    call delete(tmp)
    redraw!
    if !empty(errs)
        echohl WarningMsg
        echo join(errs)
        echohl None
    endif
endfunction
