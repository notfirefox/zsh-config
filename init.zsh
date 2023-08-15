# enable completion and prompt
autoload -Uz compinit promptinit
compinit
promptinit

# set prompt
# this currently breaks print without newline
# e.g. cat /sys/kernel/security/lsm
#prompt redhat

# set history
HISTFILE="$HOME/.zsh_history"
HISTSIZE=1000
SAVEHIST=1000

# enable colored output for grep and ls
alias grep='grep --color=auto'
alias ls='ls --color=auto --group-directories-first'

# allow case insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

# bind autosuggest acception to control space
bindkey '^ ' autosuggest-accept

# source zsh plugins
PLUGINS="/usr/share/"
#source "$PLUGINS/zsh-vi-mode/zsh-vi-mode.zsh"
source "$PLUGINS/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "$PLUGINS/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
