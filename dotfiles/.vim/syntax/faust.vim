syn keyword faustKeyword case declare letrec with
syn keyword faustKeyword soundfile waveform
syn keyword faustKeyword ffunction fvariable fconstant
syn keyword faustKeyword component environment import library
syn keyword faustKeyword par seq sum prod xor
syn keyword TODO contained TODO XXX

syn match faustLineComment contains=todo "//.*$"
syn region faustBlockComment contains=todo start="/\*"  end="\*/"
syn region faustString start=+"+  skip=+\\\\\|\\"+  end=+"\|$+

hi link faustKeyword Keyword
hi link faustLineComment Comment
hi link faustBlockComment Comment
hi link faustString String

let b:current_syntax = "faust"
