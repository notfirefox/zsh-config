# shellcheck shell=ksh
# shellcheck disable=SC2034

# Enable Korn Shell emulation. See zshbuiltins(1).
emulate -R ksh

# Select emacs keymap. See zshzle(1).
bindkey -e

# Set history-related parameters. See zshparam(1).
HISTSIZE=1000
SAVEHIST=1000
HISTFILE="$HOME/.zsh_history"

# Set wordchars parameter. See zshparam(1).
WORDCHARS=''

# Set zle_remove_suffix_chars parameter. See zshparam(1).
ZLE_REMOVE_SUFFIX_CHARS=''

# Set prompt parameter. See zshparam(1).
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

# Adjust path environment variable.
typeset -U path
if [[ -x $HOME/.ghcup/bin/ghcup ]]; then
	path=("$HOME/.ghcup/bin" "${path[@]}")
	path=("$HOME/.cabal/bin" "${path[@]}")
fi
path=("$HOME/.local/bin" "${path[@]}")

# Enable colors for commands such as ls, diff and grep.
if [[ $OSTYPE == @(freebsd*|darwin*|linux*) ]]; then
	if [[ -x /usr/bin/dircolors ]]; then
		eval "$(/usr/bin/dircolors -b)"
	fi
	if [[ $TERM_PROGRAM == Apple_Terminal ]]; then
		export COLORTERM='xterm-256color'
	fi
	export LSCOLORS='ExGxFxdaCxDaDahbadecac'

	alias ls='ls --color=auto'
	alias diff='diff --color=auto'
	alias grep='grep --color=auto'
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

# Custom backward and forward word function.
bindkey '\eb' emacs-backward-word
bindkey '\ef' emacs-forward-word

# Custom backward kill word function.
autoload -Uz backward-kill-word-match
zstyle ':zle:backward-kill-word' word-style space
zle -N backward-kill-word backward-kill-word-match

# Create unix line discard function.
function unix_line_discard {
	((CURSOR == 0)) && return 1
	zle backward-kill-line
}
zle -N unix_line_discard
bindkey '^U' unix_line_discard

# Create function that sets the terminal title.
function xterm_title_precmd {
	print -Pn -- '\e]2;%n@%m: %~\a'
}

# Install zsh hook to set the terminal title.
if [[ $TERM == @(rxvt*|xterm*) ]]; then
	emulate zsh -c 'autoload -Uz add-zsh-hook'
	add-zsh-hook -Uz precmd xterm_title_precmd
fi
