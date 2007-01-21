set ts=4 sw=4 noet nosmarttab sts=4
set comments=b:--
vm ,c :!cmt --<cr>

set term=vt100

" stop keywords from matching inside strings and comments
syntax match character "'%\=.'"
syntax region string start=+"+ skip=+%"+ end=+"+
syntax match comment "--.*"

syntax keyword reserved alias all and as check class creation debug deferred
syntax keyword reserved do else elseif end ensure expanded export external
syntax keyword reserved feature from frozen if implies indexing infix inherit
syntax keyword reserved inspect invariant is like local loop not obsolete
syntax keyword reserved old once or prefix redefine rename require rescue
syntax keyword reserved retry select separate strip then undefine
syntax keyword reserved unique until variant when xor

syntax keyword predefined Current Result True False Void Precursor

highlight reserved term=bold
highlight predefined term=underline
