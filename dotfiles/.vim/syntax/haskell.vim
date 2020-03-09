" TODO breaks it?
" if exists("b:current_syntax")
"     finish
" endif

" prevent stdlib haskell.vim from running
let b:current_syntax = "haskell"
source ~/.vim/global-syntax.vim

" syn clear
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

syn keyword   TODO     contained TODO XXX

" Backslash continues the previous line.  Vim is so bizarre.

syn match hsLineComment contains=todo,warning,hsHaddock
    \ "---*\([^-!#$%&\*\+./<=>\?@\\^|~].*\)\?$"
" Highlight haddock specially, because commenting out a guard creates a haddock
" time-bomb.
syn match hsHaddock contained " *-- |"
syn region hsBlockComment contains=todo,warning,hsBlockComment,hsHaddock
    \ start="{-"  end="-}"
syn region hsPragma    start="{-#" end="#-}"

syn match hsSpecialChar contained
    \ "\\\([0-9]\+\|o[0-7]\+\|x[0-9a-fA-F]\+\|[\"\\'&\\abfnrtv]\|^[A-Z^_\[\\\]]\)"
syn region  hsString      start=+"+  skip=+\\\\\|\\"+  end=+"\|$+
    \ contains=hsSpecialChar,strContinuation
" Backslash-continued string.
syn match strContinuation contained "\\\n *\\"

" complicated and I don't understand but it works
syn match   hsChar      "[^a-zA-Z0-9_']'\([^\\]\|\\[^']\+\|\\'\)'"lc=1
    \ contains=hsSpecialChar
syn match   hsChar      "^'\([^\\]\|\\[^']\+\|\\'\)'" contains=hsSpecialChar

" hi clear

hi link hsKeyword Keyword
hi link hsImportKeyword Keyword
hi link hsLineComment Comment
hi link hsBlockComment Comment

hi link hsPragma SpecialComment
hi hsHaddock cterm=bold ctermbg=LightRed

hi link hsString String
hi link hsSpecialChar SpecialChar

hi strContinuation ctermfg=DarkRed
hi link hsChar String

hi link hsDebug TODO
