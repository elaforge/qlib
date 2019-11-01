if [[ -d ~/qlib ]]; then
    qlib=~/qlib
elif [[ -d /net/home/elaforge/qlib ]]; then
    qlib=/net/home/elaforge/qlib
fi

if [[ -n $qlib && -e $qlib ]]; then
    # -e will fail if it's a broken link.  So replace it!
    if [[ ! -e ~/.zshrc ]]; then
        ln -sf $qlib/dotfiles/.zshrc ~
    fi
    if [[ ! -e ~/.zlogin ]]; then
        ln -sf $qlib/dotfiles/.zlogin ~
    fi

    . $qlib/dotfiles/zshenv
    if [[ ! -e ~/.vim ]]; then
        # Don't run it directly, or I get an infinite loop.
        . $qlib/mksym
    fi
fi
