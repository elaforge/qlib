augroup syntaxset
  au! FileType *        exe "set syntax=" . expand("<amatch>")
augroup END

echo "MY SYNTAX"
