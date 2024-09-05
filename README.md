# Zsh Config
Minimal Zsh Config

## :clipboard: Requirements 
- zsh
- Linux or macOS

## :package: Installation
Clone the repository into the config directory.
```sh
git clone "https://github.com/notfirefox/zsh-config.git" "$HOME/.config/zsh"
```

Set the `ZDOTDIR` environment variable.
```sh
echo 'ZDOTDIR="$HOME/.config/zsh" && . "$ZDOTDIR/.zshenv"' > "$HOME/.zshenv"
```
