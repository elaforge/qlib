" syntax sync fromstart " slow but accurate

" why no need he=s+6 to restrict highlight to import string?
syn keyword   hsKeyword   module
syn match     hsImport    "\<import\>.*" contains=hsImportKeyword
syn keyword   hsImportKeyword contained  import as qualified hiding

syn keyword   hsKeyword   infix infixl infixr
syn keyword   hsKeyword   class data deriving instance default where
syn keyword   hsKeyword   type newtype
syn keyword   hsKeyword   do case of let in
syn keyword   hsKeyword   if then else

syn keyword   hsDebug     undefined
syn keyword   Todo     contained TODO XXX

syn match   hsLineComment      contains=Todo "---*\([^-!#$%&\*\+./<=>\?@\\^|~].*\)\?$"
syn region  hsBlockComment     start="{-"  end="-}" contains=hsBlockComment
syn region  hsPragma           start="{-#" end="#-}"

" char, string (end on \n)
syn match   hsSpecialChar contained "\\\([0-9]\+\|o[0-7]\+\|x[0-9a-fA-F]\+\|[\"\\'&\\abfnrtv]\|^[A-Z^_\[\\\]]\)"
" crap no one uses
" syn match   hsSpecialChar contained "\\\(NUL\|SOH\|STX\|ETX\|EOT\|ENQ\|ACK\|BEL\|BS\|HT\|LF\|VT\|FF\|CR\|SO\|SI\|DLE\|DC1\|DC2\|DC3\|DC4\|NAK\|SYN\|ETB\|CAN\|EM\|SUB\|ESC\|FS\|GS\|RS\|US\|SP\|DEL\)"
syn region  hsString      start=+"+  skip=+\\\\\|\\"+  end=+"\|$+  contains=hsSpecialChar

" complicated and I don't understand but it works
syn match   hsChar         "[^a-zA-Z0-9_']'\([^\\]\|\\[^']\+\|\\'\)'"lc=1 contains=hsSpecialChar
syn match   hsChar         "^'\([^\\]\|\\[^']\+\|\\'\)'" contains=hsSpecialChar

hi clear
hi hsKeyword  cterm=underline
hi link hsImportKeyword hsKeyword

hi link hsLineComment hsComment
hi link hsBlockComment hsComment

hi hsComment cterm=bold
hi hsPragma cterm=bold ctermfg=DarkRed

hi hsString ctermfg=DarkBlue
hi hsSpecialChar ctermfg=DarkRed
hi link hsChar hsString

hi Todo ctermbg=Cyan
hi hsDebug ctermbg=Cyan

" ctermbg=LightGray also looks good

finish

let b:current_syntax = "haskell"
