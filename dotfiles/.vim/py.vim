setl foldmethod=indent
setl foldnestmax=3 " class, method, if
" setl foldignore=# " ignore comments

setl ai smarttab
setl ts=4 sw=4 et softtabstop=4

" google settings
" setl ts=2 sw=2 et softtabstop=2


ino <buffer> ;di     def __init__(self):<left><left>
ino <buffer> ;m		if __name__ == '__main__':<cr><tab>
ino <buffer> ;st   import pdb; pdb.set_trace()
im  <buffer> :<cr>   :<cr><tab>

setl comments=:#

" nm  ,]      /^\(def\\|class\)<cr>
" nm  ,[      ?^\(def\\|class\)<cr>

