# kill annoying default aliases and functions
# *why* must people fiddle with the default setup!?
unhash -am '*'
unhash -fm '*'
bindkey -d
# not sure where or how this gets set, but it messes up automatic path stuff
unset MANPATH

host=$(/bin/hostname -s)
if which dnsdomainname >/dev/null; then
    domain=$(dnsdomainname)
else
    domain=none
fi
export host domain
oname=$(~/bin/oname)
qlib=~/qlib

# typeset -T PATH path # automatic
# establish a:b:c <-> (a b c) link
typeset -T PYTHONPATH pythonpath
export PYTHONPATH
typeset -U path pythonpath
export PYTHONSTARTUP=$qlib/dotfiles/pythonstartup.py

path=(
    ~/bin ~/.cabal/bin ~/.cargo/bin
    $qlib/sys/$host/bin $qlib/sys/$oname/bin $qlib/sys/$domain/bin
    /usr/local/bin /usr/local/sbin
    /bin /sbin /usr/bin
)
pythonpath=(~/lib/python)

function _trydot {
    if [[ -r $1 ]]; then
        . $1
    fi
}

_trydot $qlib/sys/$host/zshenv
_trydot $qlib/sys/$domain/zshenv

export PAGER=less
export EDITOR=vim
export LESS='--RAW-CONTROL-CHARS --LONG-PROMPT --quiet'
