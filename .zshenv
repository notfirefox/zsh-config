# configure path
typeset -U path PATH
path=("$HOME/.local/bin" $path)
export PATH

# set editor variable
export EDITOR="vi"

# add homebrew to path
case "$OSTYPE" in
darwin*)
    # add homebrew to path on macos
    if [ -e /opt/homebrew ]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
    ;;
linux*)
    # add homebrew to path on linux
    if [ -e /home/linuxbrew/.linuxbrew ]; then
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    fi
    ;;
esac
