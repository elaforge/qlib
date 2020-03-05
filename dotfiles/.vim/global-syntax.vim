" Stuff all syntax files should do.

" trailing spaces are always bad
syntax match Warning   display "\s\+$"
" mixed tabs and spaces
syntax match Warning   display " \+\t"
syntax match Warning   display "\t\+ "
