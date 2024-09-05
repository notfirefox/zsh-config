# enable completion and prompt
autoload -Uz compinit promptinit
compinit
promptinit

# set prompt
prompt redhat
setopt prompt_sp

# use emacs keybindings
bindkey -e

# set history
HISTFILE="$HOME/.zsh_history"
HISTSIZE=1000
SAVEHIST=1000
