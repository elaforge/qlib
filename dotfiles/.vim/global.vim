" For some reason, :syntax goes away when I load a file.  It's too hard
" to figure out how and why, so just reset it on file loads.

" trailing spaces are always bad
syntax match ErrorMsg   display "\s\+$"
" mixed tabs and spaces
syntax match ErrorMsg   display " \+\t"
syntax match ErrorMsg   display "\t\+ "

set cpoptions=
