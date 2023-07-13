# enable completion and prompt
autoload -Uz compinit promptinit
compinit
promptinit

# set prompt
prompt redhat

# set history
HISTFILE="$HOME/.zsh_history"
HISTSIZE=1000
SAVEHIST=1000

# enable colored output for ls
alias ls='ls --color=auto --group-directories-first'

# fix for zsh-syntax-highlighting
# edit: does not seem to be necessary anymore
#ZVM_INIT_MODE='sourcing'

# allow case insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

# create alias for updating zsh plugins
alias zsh-update="git -C ${0:a:h} submodule update --remote --merge"

# source zsh plugins
source "/usr/share/zsh/plugins/zsh-vi-mode/zsh-vi-mode.zsh"
source "/usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "/usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
