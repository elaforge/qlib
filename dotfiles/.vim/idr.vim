source ~/.vim/bundle/idris-vim/ftplugin/idris.vim

" hs functions don't apply to idris
let b:did_hs_functions = 1
source ~/.vim/hs.vim

setl comments=:\|\|\|,:--

syn match idrisDocComment contains=todo,warning "^||| .*$"
hi link idrisDocComment hsComment

syn keyword idrisKeyword module namespace
syn keyword idrisKeyword import
syn keyword idrisKeyword refl
syn keyword idrisKeyword class instance
syn keyword idrisKeyword codata data record dsl interface implementation
syn keyword idrisKeyword where
syn keyword idrisKeyword public abstract private export
syn keyword idrisKeyword parameters mutual postulate using
syn keyword idrisKeyword total partial covering
syn keyword idrisKeyword implicit
syn keyword idrisKeyword auto impossible static constructor
syn keyword idrisKeyword do case of rewrite with
syn keyword idrisKeyword let in

syn match idrisMetaVar "?[a-z][A-Za-z0-9_']*"

syn match idrisDirective "%\(access\|assert_total\|default\|elim\|error_reverse\|hide\|name\|reflection\|error_handlers\|language\|flag\|dynamic\|provide\|inline\|used\|no_implicit\|hint\|extern\|unqualified\|error_handler\)"

hi link idrisKeyword hsKeyword
hi link idrisDirective hsPragma

hi idrisMetaVar cterm=bold ctermfg=DarkRed
