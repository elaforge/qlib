" For some reason, :syntax goes away when I load a file.  It's too hard
" to figure out how and why, so just reset it on file loads.

" trailing spaces are always bad
syntax match ErrorMsg   display "\s\+$"
" mixed tabs and spaces
syntax match ErrorMsg   display " \+\t"
syntax match ErrorMsg   display "\t\+ "

" mark columns 80 and 81 in red for long lines...
match ErrorMsg /\%80v.\%81v./

set cpoptions=
