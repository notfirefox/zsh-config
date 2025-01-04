# Enable subcommand completion
autoload -Uz compinit && compinit

# Load zsh hook to set terminal title later
autoload -Uz add-zsh-hook

# Use emacs style keybindings for better compatibility
bindkey -e

# Enable history for `CONTROL+R` functionality
HISTSIZE=1000
SAVEHIST=1000
HISTFILE="$HOME/.zsh_history"

# Change history settings to be more like bash on Linux
setopt append_history
setopt hist_ignore_dups
setopt hist_ignore_space

# Make `ALT+B` and `ALT+F` behave like in bash
WORDCHARS=''

# Do not automatically remove suffix chars
ZLE_REMOVE_SUFFIX_CHARS=''

# Configure shell behaviour to be more like bash on Linux
setopt sh_glob
setopt ksh_glob
setopt ksh_arrays
setopt sh_nullcmd
setopt sh_word_split
setopt bash_auto_list
unsetopt nomatch
unsetopt auto_menu
unsetopt bad_pattern
unsetopt bare_glob_qual
unsetopt always_last_prompt
unsetopt auto_remove_slash

# Use a colorful prompt for better visibility
PROMPT="%F{green}%B%n@%m%b%f:%F{blue}%B%~%b%f%(!.#.$) "

# Configure the path environment variable
typeset -U path
path=(~/.local/bin ~/.cabal/bin ~/.ghcup/bin "${path[@]}")

# Set editor and visual variables
export EDITOR=ed
export VISUAL=vi

# Configure ex and vi editor
export EXINIT="set ai nofl"
export NEXINIT="$EXINIT filec=\	"

# Enable colors for common commands such as ls and grep
case "$OSTYPE" in
darwin*)
	export CLICOLOR=1
	# Add Homebrew to path if it is installed
	if [[ -d "/opt/homebrew" ]]; then
		eval "$(/opt/homebrew/bin/brew shellenv)"
	fi
	;;
linux*)
	if [[ -x /usr/bin/dircolors ]]; then
		eval "$(dircolors -b)"
	fi
	alias diff='diff --color=auto'
	alias grep='grep --color=auto'
	alias ls='ls --color=auto'
	;;
esac

# Add command not found handler for Debian-based systems
function command_not_found_handler {
	if [[ -x /usr/lib/command-not-found ]]; then
		/usr/lib/command-not-found -- "$1"
		return $?
	fi
	printf "%s: command not found\n" "$1" >&2
	return 127
}

# Add xterm title precmd
function xterm_title_precmd {
	print -Pn -- '\e]2;%n@%m: %~\a'
}

# Install zsh hook to set the terminal title
if [[ "$TERM" == @(rxvt*|xterm*) ]]; then
	add-zsh-hook -Uz precmd xterm_title_precmd
fi
