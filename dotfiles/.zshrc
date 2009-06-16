alias s='command ls -F --color=tty'
alias ll='s -l'
alias la='s -a'
alias ss='s -Ss'
alias l=less
alias zreset='exec $SHELL'
alias rr='rm -rf'
alias vi='command vim -X'
alias ssh='ssh -C'
alias cwd='cd $(command pwd)'
alias pwd='command pwd'

PS1='%B%(?..%?)%#%b '
RPS1='%~%(6~.. %B%n%b@%U%m%u)'

_trydot $qlib/dotfiles/set-ls-colors $TERM

fignore=(.o .pyc .pyo .hi .class)

# stty erase '^H'
stty erase ''
# stty susp '^Z'
# stty intr '^C'
stty -ixon # turn off annoying software flow control

bindkey -v
bindkey		'' backward-delete-char
bindkey -a	'' backward-delete-char
bindkey		'' backward-delete-char
bindkey -a	'' backward-delete-char
bindkey		'' push-line
bindkey -a	'' push-line
bindkey		'' history-incremental-search-backward
bindkey -a	'' history-incremental-search-backward

# bindkey	 '[A' up-line-or-history
# bindkey	 '[B' down-line-or-history
# bindkey	 '[D' backward-char
# bindkey	 '[C' forward-char

setopt extendedglob nobgnice noflowcontrol histignoredups nohup
setopt interactivecomments listtypes longlistjobs
setopt nobeep

HISTSIZE=300

host_complete=($(<$qlib/dotfiles/hosts))
if [[ -r $qlib/sys/$host/hosts ]]; then
	host_complete=($(<$qlib/sys/$host/hosts) $host_complete)
fi
scpary=(${^host_complete}:)
compctl -k host_complete telnet ssh
compctl -f + -k host_complete -S : scp

function conf {
	ac_cv_prog_cc_g=no ac_cv_prog_cxx_g=no ./configure $*
}

if [[ $TERM = linux ]]; then
	LESS=-MqE
else
	LESS=-Mq
fi
export LESS

if [[ $TERM == xterm ]]; then
	function chpwd {
		print -nP "\033]2;tty%l: %~\007\033]1;tty%l: %~\007"
	}
	chpwd
	# func 'preexec' executed before each command
fi

_trydot $qlib/sys/$host/zshrc
_trydot $qlib/sys/$domain/zshrc
