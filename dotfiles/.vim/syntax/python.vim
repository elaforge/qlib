" if exists("b:current_syntax")
"     finish
" endif

let b:current_syntax = "python"
" source ~/.vim/global-syntax.vim

syntax sync fromstart " slow but accurate

syn keyword Keyword
    \ False      await      else       import     pass
    \ None       break      except     in         raise
    \ True       class      finally    is         return
    \ and        continue   for        lambda     try
    \ as         def        from       nonlocal   while
    \ assert     del        global     not        with
    \ async      elif       if         or         yield

syn region  String      start=+"+  skip=+\\\\\|\\"+  end=+"\|$+
syn region  String      start=+'+  skip=+\\\\\|\\'+  end=+'\|$+
syn region  String      contains=Warning start=+"""+  end=+"""+
syn region  String      contains=Warning start=+'''+  end=+'''+

hi link multilineString String

syn match Comment contains=todo,warning "#.*$"

syn keyword   TODO     contained TODO XXX

" No tabs at all.
syntax match Warning   display "\s\+$"
syntax match Warning   display "\t"
