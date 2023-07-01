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
HISTFILE="$HOME/.zsh_history"

# Set WORDCHARS parameter. See zshparam(1).
WORDCHARS=''

# Set ZLE_REMOVE_SUFFIX_CHARS parameter. See zshparam(1).
ZLE_REMOVE_SUFFIX_CHARS=''

# Set PROMPT parameter. See zshparam(1).
PROMPT="%F{green}%B%n@%m%b%f:%F{blue}%B%~%b%f%(!.#.$) "

# Set interactive shell options. See zshoptions(1).
setopt append_history
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

# Set IEEE Std 1003.1-2024 compliant environment variables.
export EDITOR=ed
export VISUAL=vi
export EXINIT='set noflash'

# Create aliases for nvi(1), nex(1) and nview(1).
command -v nvi >/dev/null 2>&1 && alias vi='nvi'
command -v nex >/dev/null 2>&1 && alias ex='nex'
command -v nview >/dev/null 2>&1 && alias view='nview'

# Create aliases for wl-copy(1) and wl-paste(1).
command -v wl-copy >/dev/null 2>&1 && alias pbcopy='wl-copy'
command -v wl-paste >/dev/null 2>&1 && alias pbpaste='wl-paste'

# Adjust path environment variable.
typeset -U path
if [[ -r $HOME/.ghcup/env ]]; then
	. "$HOME"/.ghcup/env
fi
if [[ -r $HOME/.local/share/swiftly/env.sh ]]; then
	. "$HOME"/.local/share/swiftly/env.sh
fi
path=("$HOME/.local/bin" "${path[@]}")

# Set COLORTERM for Apple terminal. See ls(1).
if [[ $TERM_PROGRAM == Apple_Terminal ]]; then
	export COLORTERM='xterm-256color'
fi

# Set LS_COLORS environment variable. See dircolors(1).
if [[ -x /usr/bin/dircolors ]]; then
	eval "$(/usr/bin/dircolors -b)"
fi

# Set LSCOLORS environment variable. See ls(1).
export LSCOLORS='ExGxFxdaCxDaDahbadecac'

# Create alias for diff. See diff(1).
if command diff --color=auto /dev/null{,} >/dev/null 2>&1; then
	alias diff='diff --color=auto'
fi

# Create alias for grep. See grep(1).
if echo | command grep --color=auto "" >/dev/null 2>&1; then
	alias grep='grep --color=auto'
fi

# Create alias for ls. See ls(1).
if command ls --color=auto / >/dev/null 2>&1; then
	alias ls='ls --color=auto'
elif command ls -G / >/dev/null 2>&1; then
	alias ls='ls -G'
fi

# Create command not found handler. See zshmisc(1).
function command_not_found_handler {
	if [[ -x /usr/lib/command-not-found ]]; then
		/usr/lib/command-not-found -- "$1"
		return $?
	fi
	printf "%s: command not found\n" "$1" >&2
	return 127
}

# Redefine backward-word function. See zshzle(1).
function backward-word { zle .emacs-backward-word; }
zle -N backward-word

# Redefine forward-word function. See zshzle(1).
function forward-word { zle .emacs-forward-word; }
zle -N forward-word

# Redefine backward-kill-word function. See zshzle(1).
autoload -Uz backward-kill-word-match
zstyle ':zle:backward-kill-word' word-style space
zle -N backward-kill-word backward-kill-word-match

# Redefine backward-kill-line function. See zshzle(1).
function backward-kill-line {
	((CURSOR == 0)) && return 1
	zle .backward-kill-line
}
zle -N backward-kill-line
bindkey '^U' backward-kill-line

# Redefine backward-delete-char function. See zshzle(1).
function backward-delete-char {
	((CURSOR == 0)) && return 1
	zle .backward-delete-char
}
zle -N backward-delete-char

# Redefine transpose-chars function. See zshzle(1).
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
