# Zsh Config
Minimal Zsh Config

## Installation
Clone the repository into your config folder.
```sh
git clone "https://github.com/notfirefox/zsh-config.git" "$HOME/.config/zsh"
```

Now all that it is left is to set `ZDOTDIR`.
```sh
echo 'export ZDOTDIR="$HOME/.config/zsh"' > "$HOME/.zprofile"
```

The config will be ready the next time you log into your system.
