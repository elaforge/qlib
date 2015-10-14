syn sync fromstart " slow but accurate

syn keyword rsDebug     undefined error
syn keyword rsKeyword   abstract        alignof as      become  box
syn keyword rsKeyword   break   const   continue        crate   do
syn keyword rsKeyword   else    enum    extern  false   final
syn keyword rsKeyword   fn      for     if      impl    in
syn keyword rsKeyword   let     loop    macro   match   mod
syn keyword rsKeyword   move    mut     offsetof        override        priv
syn keyword rsKeyword   proc    pub     pure    ref     return
syn keyword rsKeyword   Self    self    sizeof  static  struct
syn keyword rsKeyword   super   trait   true    type    typeof
syn keyword rsKeyword   unsafe  unsized use     virtual where
syn keyword rsKeyword   while   yield
syn region  rsAnnotation start="#!\?\[" end="\]" contains=rsString

syn keyword   todo     contained TODO XXX

" trailing spaces are always bad
syn match warning   display "\s\+$"
" mixed tabs and spaces
syn match warning   display " \+\t"
syn match warning   display "\t\+ "

" Backslash continues the previous line.  Vim is so bizarre.

syn match rsLineComment contains=todo,warning
    \ "///*\([^-!#$%&\*\+./<=>\?@\\^|~].*\)\?$"
syn region  rsBlockComment contains=todo,warning,rsBlockComment
    \ start="/\*"  end="\*/"

syn match   rsSpecialChar contained
    \ "\\\([0-9]\+\|o[0-7]\+\|x[0-9a-fA-F]\+\|[\"\\'&\\abfnrtv]\|^[A-Z^_\[\\\]]\)"
syn region  rsString      start=+"+  skip=+\\\\\|\\"+  end=+"\|$+
    \ contains=rsSpecialChar,strContinuation
" Backslash-continued string.
syn match strContinuation contained "\\\n *\\"

" complicated and I don't understand but it works
syn match   rsChar      "[^a-zA-Z0-9_']'\([^\\]\|\\[^']\+\|\\'\)'"lc=1
    \ contains=rsSpecialChar
syn match   rsChar      "^'\([^\\]\|\\[^']\+\|\\'\)'" contains=rsSpecialChar

hi clear
hi link warning ErrorMsg

hi rsKeyword  cterm=underline

hi link rsLineComment rsComment
hi link rsBlockComment rsComment
hi rsComment cterm=bold
hi rsAnnotation cterm=bold ctermfg=DarkRed

hi rsString ctermfg=DarkBlue
hi rsSpecialChar ctermfg=DarkRed
hi strContinuation ctermfg=DarkRed
hi link rsChar rsString

hi todo ctermbg=Cyan
hi rsDebug ctermbg=Cyan

" ctermbg=LightGray also looks good

finish

let b:current_syntax = "rust"
