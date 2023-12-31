# enable completion and prompt
autoload -Uz compinit
compinit

# set prompt
PROMPT='[%n@%m %.]%(!.#.$) '

# set history
HISTFILE="$HOME/.zsh_history"
HISTSIZE=1000
SAVEHIST=1000

# user specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]
then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# set editor variable
export EDITOR="vi"

# file permissions command
function fp() {
    if [ $# -eq 0 ]; then
        stat -c '%a - %n' *
    else
        stat -c '%a - %n' "$@"
    fi
}

# enable colored output for grep and ls
alias grep='grep --color=auto'
alias ls='ls --color=auto --group-directories-first'

# allow case insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

# source zsh plugins
source "${0:a:h}/zsh-vi-mode/zsh-vi-mode.plugin.zsh"
source "${0:a:h}/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "${0:a:h}/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

# accept auto suggestion using ctrl space
function zvm_after_init() {
    zvm_bindkey viins '^ ' autosuggest-accept
}
