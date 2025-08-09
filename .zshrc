# shellcheck shell=ksh
# shellcheck disable=SC1091
# shellcheck disable=SC2034

# Enable Korn Shell emulation. See zshbuiltins(1).
emulate -R ksh

# Select emacs keymap. See zshzle(1).
bindkey -e

# Set history-related parameters. See zshparam(1).
HISTSIZE=1000
SAVEHIST=1000
HISTFILE="$HOME"/.zsh_history

# Set WORDCHARS parameter. See zshparam(1).
WORDCHARS=''

# Set ZLE_REMOVE_SUFFIX_CHARS parameter. See zshparam(1).
ZLE_REMOVE_SUFFIX_CHARS=''

# Set PROMPT parameter. See zshparam(1).
PROMPT="%F{green}%B%n@%m%b%f:%F{blue}%B%~%b%f%(!.#.$) "

# Set interactive shell options. See zshoptions(1).
setopt append_history
setopt bang_hist
setopt bash_auto_list
setopt hist_ignore_dups
setopt hist_ignore_space
setopt no_always_last_prompt
setopt no_auto_menu
setopt no_auto_remove_slash
setopt no_single_line_zle
setopt prompt_percent

# Setup shell environment according to Homebrew.
if [[ -x /opt/homebrew/bin/brew ]]; then
	eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Enable new completion system. See zshcompsys(1).
emulate zsh -c 'autoload -Uz compinit'
compinit

# Set POSIX.1-2024 compliant environment variables.
export EDITOR=ed
export VISUAL=vi
export PAGER=less

# Set options for the less(1) command.
export LESS=FRX

# Customize behavior for the man(1) command.
function man { LESS='' MANLESS='' command man "$@"; }

# Adjust path environment variable.
if [[ $PATH != *"$HOME/.local/bin:"* ]]; then
	export PATH="$HOME/.local/bin:$PATH"
fi

# Configure colors for the ls(1) command on macOS.
export COLORTERM=${COLORTERM:-yes}
export LSCOLORS='ExGxFxdaCxDaDahbadecac'

# Configure colors for the ls(1) command on Linux.
[[ -x /usr/bin/dircolors ]] &&
	eval "$(/usr/bin/dircolors -b)"

# Enable colors for the diff(1) command.
command diff --color=auto /dev/null{,} >/dev/null 2>&1 &&
	alias diff='diff --color=auto'

# Enable colors for the grep(1) command.
echo | command grep --color=auto "" >/dev/null 2>&1 &&
	alias grep='grep --color=auto'

# Enable colors for the ls(1) command.
command ls --color=auto / >/dev/null 2>&1 &&
	alias ls='ls --color=auto'

# Some useful aliases. See zshbuiltins(1).
alias m='$PAGER'

# Create command not found handler. See zshmisc(1).
[[ -r /etc/zsh_command_not_found ]] &&
	. /etc/zsh_command_not_found

# Redefine backward-word and forward-word zshzle(1) functions.
zle -A emacs-forward-word forward-word
zle -A emacs-backward-word backward-word

# Redefine backward-kill-word zshzle(1) function.
autoload -Uz backward-kill-word-match
zstyle ':zle:backward-kill-word' word-style space
zle -N backward-kill-word backward-kill-word-match

# Redefine beginning-of-line zshzle(1) function.
function beginning-of-buffer { CURSOR=0; }
zle -N beginning-of-line beginning-of-buffer

# Redefine end-of-line zshzle(1) function.
function end-of-buffer { CURSOR=${#BUFFER}; }
zle -N end-of-line end-of-buffer

# Redefine backward-kill-line zshzle(1) function.
function backward-kill-buffer {
	((CURSOR == 0)) && return 1
	zle .copy-region-as-kill "${BUFFER:0:$CURSOR}"
	BUFFER="${BUFFER:$CURSOR}"
	CURSOR=0
}
zle -N backward-kill-line backward-kill-buffer
bindkey '^U' backward-kill-line

# Redefine kill-line zshzle(1) function.
function forward-kill-buffer {
	zle .copy-region-as-kill "${BUFFER:$CURSOR}"
	BUFFER="${BUFFER:0:$CURSOR}"
	CURSOR=${#BUFFER}
}
zle -N kill-line forward-kill-buffer

# Redefine backward-delete-char zshzle(1) function.
function backward-delete-char {
	((CURSOR == 0)) && return 1
	zle .backward-delete-char
}
zle -N backward-delete-char

# Redefine transpose-chars zshzle(1) function.
function transpose-chars {
	((CURSOR == 0)) && return 1
	zle .transpose-chars
}
zle -N transpose-chars

# Define function that sets the terminal title.
if typeset -f update_terminal_cwd >/dev/null 2>&1; then
	function xterm_title_precmd {
		emulate zsh -c update_terminal_cwd
	}
else
	function xterm_title_precmd {
		print -Pn -- '\e]2;%n@%m: %~\a'
	}
fi

# Install zsh hook to set the terminal title.
if [[ $TERM == @(rxvt*|xterm*) ]]; then
	autoload -Uz add-zsh-hook
	add-zsh-hook precmd xterm_title_precmd
	add-zsh-hook -d precmd update_terminal_cwd
fi
