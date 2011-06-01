" options for haskell
setl foldmethod=indent
" this makes tags work on qualified names
" setl iskeyword=a-z,A-Z,_,.,39

setl comments=:--
" replace c with t since vi's idea of comments will be backwards
setl formatoptions=troq1

setl ai
setl smarttab

" haskell has lots of \(...) so don't do the special \ treatment
setl cpoptions+=M

vm <buffer> ,c :!cmt --<cr>

" intentional trailing space
ino <buffer> ;i import qualified 

" Make gf work on module import lines.
setl includeexpr=substitute(v:fname,'\\.','/','g')
setl suffixesadd=.hsc,.hs

nm <silent> ,t :exec ToggleTest()<cr>
nm <silent> ,a :call FixImports()<cr>

source ~/.vim/hs-syntax.vim

if exists("*ToggleTest")
    finish
endif

function ToggleTest()
    let filename = expand('%')
    if match(filename, '_test\.hs$') != -1
        let filename = substitute(filename, '_test\.hs', '.hs', '')
    else
        let filename = substitute(filename, '\.hs', '_test.hs', '')
    endif
    return ":edit " . filename
endfunction

" A ghci command can use this to load the currently edited file.
function SaveFile()
    " how to wrap long lines in vim?
    call writefile([substitute(expand('%'), "//", "/", "g")], $HOME . "/.vim/current_hs")
endfunction

" Run the contents of the current buffer through the FixImports cmd.  Print
" any stderr output on the status line.
function FixImports()
    let out = tempname()
    let err = tempname()
    let tmp = tempname()
    " Using a tmp file means I don't have to save the buffer, which the user
    " didn't ask for.
    execute 'write' tmp
    execute 'silent !FixImports -v' expand('%') '<' tmp '>' out '2>' err
    let errs = readfile(err)
    if v:shell_error == 0
        " Is there an easier way to replace the buffer with a file?
        let old_line = line('.')
        let old_col = col('.')
        %d
        execute 'silent :read' out
        0d
        call cursor(old_line, old_col)
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

au BufEnter *.hs call SaveFile()
