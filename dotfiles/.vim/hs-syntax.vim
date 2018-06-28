syn clear
syntax sync fromstart " slow but accurate

" why no need he=s+6 to restrict highlight to import string?
syn keyword hsKeyword   module
syn match   hsImport    "\<import\>.*" contains=hsImportKeyword,hsLineComment
syn keyword hsImportKeyword contained  import as qualified hiding

syn keyword hsKeyword   infix infixl infixr
syn keyword hsKeyword   class data deriving instance default where
syn keyword hsKeyword   type newtype
syn keyword hsKeyword   do case of let in
syn keyword hsKeyword   if then else

syn keyword hsDebug     undefined error

syn keyword   todo     contained TODO XXX

" trailing spaces are always bad
syntax match warning   display "\s\+$"
" no tabs
syntax match warning   display "\t\+"

" Backslash continues the previous line.  Vim is so bizarre.

syn match hsLineComment contains=todo,warning
    \ "---*\([^-!#$%&\*\+./<=>\?@\\^|~].*\)\?$"
syn region  hsBlockComment contains=todo,warning,hsBlockComment
    \ start="{-"  end="-}"
syn region  hsPragma    start="{-#" end="#-}"

syn match   hsSpecialChar contained
    \ "\\\([0-9]\+\|o[0-7]\+\|x[0-9a-fA-F]\+\|[\"\\'&\\abfnrtv]\|^[A-Z^_\[\\\]]\)"
syn region  hsString      start=+"+  skip=+\\\\\|\\"+  end=+"\|$+
    \ contains=hsSpecialChar,strContinuation
" Backslash-continued string.
syn match strContinuation contained "\\\n *\\"

" complicated and I don't understand but it works
syn match   hsChar      "[^a-zA-Z0-9_']'\([^\\]\|\\[^']\+\|\\'\)'"lc=1
    \ contains=hsSpecialChar
syn match   hsChar      "^'\([^\\]\|\\[^']\+\|\\'\)'" contains=hsSpecialChar

hi clear
hi link warning ErrorMsg

hi hsKeyword cterm=underline
hi link hsImportKeyword hsKeyword

hi link hsLineComment hsComment
hi link hsBlockComment hsComment

hi hsComment cterm=bold
hi hsPragma cterm=bold ctermfg=DarkRed

hi hsString ctermfg=DarkBlue
hi hsSpecialChar ctermfg=DarkRed
hi strContinuation ctermfg=DarkRed
hi link hsChar hsString

hi todo ctermbg=Cyan
hi hsDebug ctermbg=Cyan

" ctermbg=LightGray also looks good

finish

let b:current_syntax = "haskell"
