unset MANPATH

alias s='command ls -F --color=tty'
alias ll='s -lh'
alias la='s -a'
alias ss='s -Ss'
alias l=less
alias zreset='exec $SHELL'
alias rr='rm -rf'
alias vi='vim'
alias ssh='ssh -C'
alias cwd='cd $(command pwd)'
alias pwd='command pwd'
alias od='od -A x -taxC'

alias d=darcs
alias cha='darcs changes | l'
alias dw='darcs w -l'

# git
alias g=git
function gog() { git log --decorate=short "$@" | l }


# history
setopt inc_append_history # session histories will be interleaved
setopt hist_save_no_dups
HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=10000

export DARCS_DONT_ESCAPE_8BIT=1
# Change obnoxious warnings magenta 35 to blue 34.
export GHC_COLOURS='header=:message=1:warning=1;34:error=1;31:fatal=1;31:margin=1;34'
# Otherwise it's ^^, which is used by vi.
export MOSH_ESCAPE_KEY=

# cd to copy and pasted prompt
function ccd {
    # skip over % prompt and get the first word afterwards
    if [[ $1 = *% ]]; then shift; fi
    cd $1
}

# PS1='%B%(?..%?)%#%b '
PS1='%K{cyan}%(?..%?)%# %k'
RPS1='%~%(6~.. %B%n%b@%U%m%u)'

_trydot $qlib/dotfiles/set-ls-colors $TERM

fignore=(.o .pyc .pyo .hi .hi-boot .o-boot .class)

stty erase '^H'
# stty susp '^Z'
# stty intr '^C'
stty -ixon -ixoff # turn off annoying software flow control

bindkey -v
bindkey		'' backward-delete-char
bindkey -a	'' backward-delete-char
bindkey		'' backward-delete-char
bindkey -a	'' backward-delete-char
bindkey		'' push-line
bindkey -a	'' push-line
bindkey		'' history-incremental-search-backward
bindkey -a	'' history-incremental-search-backward

# bindkey         '[A' up-line-or-history
# bindkey         '[B' down-line-or-history
# bindkey         '[D' backward-char
# bindkey         '[C' forward-char

setopt extendedglob nobgnice noflowcontrol histignoredups nohup
setopt interactivecomments listtypes longlistjobs
setopt nobeep

HISTSIZE=300

host_complete=($(<$qlib/dotfiles/hosts))
if [[ -r $qlib/sys/$host/hosts ]]; then
    host_complete=($(<$qlib/sys/$host/hosts) $host_complete)
fi
compctl -k host_complete telnet ssh mosh
compctl -f + -k host_complete -S : scp rsync darcs d

function git_refs() {
    reply=($(git for-each-ref --format='%(refname:short)' "refs/heads/$1*"))
}
# checkout and branch complete on branches, or filename.
# Otherwise, complete filenames.
# compctl -x 'w[1,co][1,checkout][1,b][1,branch][1,m][1,d][1,rebase]' \
#     -K git_refs -f + -f -- + -f git g
compctl -K git_refs -f git g gog

if [[ $TERM == xterm ]]; then
    function chpwd {
        print -nP "\033]2;tty%l: %~\007\033]1;tty%l: %~\007"
    }
    chpwd
    # func 'preexec' executed before each command
fi

_trydot $qlib/sys/$host/zshrc
_trydot $qlib/sys/$domain/zshrc
