# kill annoying default aliases and functions
# *why* must people fiddle with the default setup!?
unhash -am '*'
unhash -fm '*'
bindkey -d

# typeset -T PATH path # automatic
# establish a:b:c <-> (a b c) link
typeset -T PYTHONPATH pythonpath
export PYTHONPATH
typeset -U path pythonpath
export PYTHONSTARTUP=$HOME/.pythonstartup.py

host=$(/bin/hostname -s)
# if which dnsdomainname; then
# 	domain=$(dnsdomainname)
# else
	domain=none
# fi
oname=$(~/bin/oname)
qlib=~/qlib

path=($qlib/sys/$host/bin $qlib/sys/$oname/bin ~/bin /usr/local/bin $path)
pythonpath=(~/lib/python)

function _trydot {
	if [[ -r $1 ]]; then
		. $1
	fi
}

_trydot $qlib/sys/$host/zshenv
_trydot $qlib/sys/$domain/zshenv

export PAGER='less -is'
export EDITOR=vim
export LESS=-f
