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
setopt sh_nullcmd
setopt no_auto_menu
setopt bash_auto_list
setopt no_auto_remove_slash
setopt no_always_last_prompt

bindterm() {
    local sequence widget
    sequence="${terminfo[$1]}"
    widget="$2"

    [[ -z "$sequence" ]] && return 1
    bindkey -- "$sequence" "$widget"
}

# bind keys using terminfo
bindterm kbs   backward-delete-char
bindterm khome beginning-of-line
bindterm kend  end-of-line
bindterm kich1 overwrite-mode
bindterm kdch1 delete-char
bindterm kcuu1 up-line-or-history
bindterm kcud1 down-line-or-history
bindterm kcub1 backward-char
bindterm kcuf1 forward-char
bindterm kpp   beginning-of-buffer-or-history
bindterm knp   end-of-buffer-or-history

# make sure the terminal is in application mode, when zle is
# active. only then are the values from $terminfo valid.
if (( ${+terminfo[smkx]} )) && (( ${+terminfo[rmkx]} )); then
    zle-line-init() {
        emulate -L zsh
        printf '%s' ${terminfo[smkx]}
    }
    zle-line-finish() {
        emulate -L zsh
        printf '%s' ${terminfo[rmkx]}
    }
    zle -N zle-line-init
    zle -N zle-line-finish
fi

# unfunction bindterm
unfunction bindterm
