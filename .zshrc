# enable completion and prompt
autoload -Uz compinit promptinit
compinit
promptinit

# set prompt
prompt redhat
setopt prompt_sp

# set history
HISTFILE="$HOME/.zsh_history"
HISTSIZE=1000
SAVEHIST=1000

# dev container command
# alias dev='[ -f "/run/.toolboxenv" ] || exec toolbox enter'
alias dev='exec distrobox enter "fedora"'

# enable colored output for grep and ls
alias grep='grep --color=auto'
alias ls='ls --color=auto --group-directories-first'

# allow case insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

# load plugin function
load_plugins() {
  local repo plugdir initfile initfiles=()
  : ${ZPLUGINDIR:=${ZDOTDIR:-~/.config/zsh}/plugins}
  for repo in $@; do
    plugdir=$ZPLUGINDIR/${repo:t}
    initfile=$plugdir/${repo:t}.plugin.zsh
    if [[ ! -d $plugdir ]]; then
      echo "Cloning $repo..."
      git clone -q --depth 1 --recursive --shallow-submodules \
        "https://github.com/$repo" $plugdir
    fi
    if [[ ! -e $initfile ]]; then
      initfiles=($plugdir/*.{plugin.zsh,zsh-theme,zsh,sh}(N))
      (( $#initfiles )) || { echo >&2 "No init file '$repo'." && continue }
      ln -sf $initfiles[1] $initfile
    fi
    fpath+=$plugdir
    (( $+functions[zsh-defer] )) && zsh-defer . $initfile || . $initfile
  done
}

# plugins
plugins=(
    jeffreytse/zsh-vi-mode
    zsh-users/zsh-autosuggestions
    zsh-users/zsh-syntax-highlighting
)

# load plugins
load_plugins $plugins

# accept auto suggestion using ctrl space
zvm_after_init() {
    zvm_bindkey viins '^ ' autosuggest-accept
}
