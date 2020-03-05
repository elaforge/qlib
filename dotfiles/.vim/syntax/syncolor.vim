" hi link hsImportKeyword Keyword
" hi link hsLineComment Comment
" hi link hsBlockComment Comment
" hi hsPragma cterm=bold ctermfg=DarkRed
" hi strContinuation ctermfg=DarkRed
" hi link hsChar hsString
" hi hsDebug ctermbg=Cyan

" Stuff all syntax files should do.

" trailing spaces are always bad
syntax match Warning   display "\s\+$"
" mixed tabs and spaces
syntax match Warning   display " \+\t"
syntax match Warning   display "\t\+ "

hi link Warning ErrorMsg

hi Keyword cterm=underline
hi Comment cterm=bold
hi SpecialComment cterm=bold ctermfg=DarkRed
hi String ctermfg=DarkBlue
hi SpecialChar ctermfg=DarkRed
hi TODO ctermbg=Cyan
