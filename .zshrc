# enable completion and prompt
autoload -Uz compinit promptinit
compinit
promptinit

# set prompt
prompt redhat
setopt prompt_sp

# set keybindings
bindkey -e

# set history
HISTFILE="$HOME/.zsh_history"
HISTSIZE=1000
SAVEHIST=1000

# set wordchars
WORDCHARS=''

# set options
setopt no_auto_menu
setopt bash_auto_list
setopt no_always_last_prompt
