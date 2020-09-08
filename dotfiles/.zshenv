qlibs=(
    ~/qlib
    ~/elaforge/qlib
    /net/home/elaforge/qlib
    /labshare/elaforge/qlib
    /lab/elaforge/qlib
)
for qlib in $qlibs; do
    if [[ -d $qlib ]]; then
        break
    fi
done
unset qlibs

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
