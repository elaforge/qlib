if [[ -d ~/qlib ]]; then
    qlib=~/qlib
elif [[ -d /net/home/elaforge/qlib ]]; then
    qlib=/net/home/elaforge/qlib
else
    echo no qlib
fi

if [[ -n $qlib ]]; then
    if [[ ! -e ~/.zshrc && -e $qlib/dotfiles/.zshrc ]]; then
        ln -s $qlib/dotfiles/.zshrc ~
    fi
    if [[ ! -e ~/.zlogin && -e $qlib/dotfiles/.zlogin ]]; then
        ln -s $qlib/dotfiles/.zlogin ~
    fi

    . $qlib/dotfiles/zshenv
fi
