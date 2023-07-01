# enable completion
autoload -Uz compinit
compinit

# set history
HISTFILE="$HOME/.zsh_history"
HISTSIZE=1000
SAVEHIST=1000

# set prompt
PROMPT='[%n@%m %.]%(!.#.$) '

# enable colored output for ls
alias ls='ls --color=auto --group-directories-first'

# fix for zsh-syntax-highlighting
ZVM_INIT_MODE='sourcing'

# allow case insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

# create alias for updating zsh plugins
alias zsh-update="git -C ${0:a:h} submodule update --remote --merge"

# source zsh plugins
source "${0:a:h}/zsh-vi-mode/zsh-vi-mode.plugin.zsh"
source "${0:a:h}/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "${0:a:h}/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
