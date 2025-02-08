# Enable subcommand completion
emulate zsh -c 'autoload -Uz compinit'
compinit

# Enable ksh emulation
emulate -R ksh

# Use emacs style keybindings for better compatibility
bindkey -e

# Enable history for `CONTROL+R` functionality
HISTSIZE=1000
SAVEHIST=1000
HISTFILE="$HOME/.zsh_history"

# Change word chars to be more like GNU readline
WORDCHARS=''

# Do not automatically remove suffix chars
ZLE_REMOVE_SUFFIX_CHARS=''

# Use a colorful prompt for better visibility
PROMPT="%F{green}%B%n@%m%b%f:%F{blue}%B%~%b%f%(!.#.$) "

# Configure interactive shell behaviour
setopt append_history
setopt bash_auto_list
setopt hist_ignore_dups
setopt hist_ignore_space
setopt no_always_last_prompt
setopt no_auto_menu
setopt no_auto_remove_slash
setopt no_single_line_zle
setopt prompt_percent

# Set editor and visual variables
export EDITOR=ed
export VISUAL=vi

# Configure ex and vi editor
export EXINIT="set nofl"
export NEXINIT="$EXINIT filec=\	"

# Add Homebrew to path if it is installed
if [[ -x /opt/homebrew/bin/brew ]]; then
	eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Configure the path environment variable
typeset -U path
if [[ -x $HOME/.ghcup/bin/ghcup ]]; then
	path=("$HOME/.cabal/bin" "$HOME/.ghcup/bin" "${path[@]}")
fi
path=("$HOME/.local/bin" "${path[@]}")

# Enable colors for commands such as ls, diff and grep
if [[ $OSTYPE == linux-gnu ]]; then
	eval "$(/usr/bin/dircolors -b)"
	alias ls='ls --color=auto'
elif [[ $OSTYPE == @(darwin*|freebsd*) ]]; then
	export LSCOLORS="ExGxFxdaCxDaDahbadecac"
	alias ls='ls -G'
fi
alias diff='diff --color=auto'
alias grep='grep --color=auto'

# Add command not found handler for Debian-based systems
function command_not_found_handler {
	if [[ -x /usr/lib/command-not-found ]]; then
		/usr/lib/command-not-found -- "$1"
		return $?
	fi
	printf "%s: command not found\n" "$1" >&2
	return 127
}

# Create custom unix line discard function
function unix_line_discard {
	case "$CURSOR" in
	0) zle beep ;;
	*) zle backward-kill-line ;;
	esac
}
zle -N unix_line_discard
bindkey '^U' unix_line_discard

# Add xterm title precmd
function xterm_title_precmd {
	print -Pn -- '\e]2;%n@%m: %~\a'
}

# Install zsh hook to set the terminal title
if [[ $TERM == @(rxvt*|xterm*) ]]; then
	autoload -Uz add-zsh-hook
	add-zsh-hook -Uz precmd xterm_title_precmd
fi
