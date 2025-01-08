# Enable subcommand completion
autoload -Uz compinit && compinit

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

# Configure shell behaviour to be more like bash/ksh
setopt append_history
setopt bash_auto_list
setopt glob_subst
setopt hist_ignore_dups
setopt hist_ignore_space
setopt interactive_comments
setopt ksh_arrays
setopt ksh_glob
setopt no_always_last_prompt
setopt no_auto_menu
setopt no_auto_remove_slash
setopt no_bad_pattern
setopt no_bare_glob_qual
setopt no_equals
setopt no_function_argzero
setopt no_nomatch
setopt sh_file_expansion
setopt sh_glob
setopt sh_nullcmd
setopt sh_word_split

# Configure the path environment variable
typeset -U path
path=(~/.local/bin ~/.cabal/bin ~/.ghcup/bin "${path[@]}")

# Set editor and visual variables
export EDITOR=ed
export VISUAL=vi

# Configure ex and vi editor
export EXINIT="set nofl"
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

# Create custom unix line discard function
function unix_line_discard {
	if [[ $CURSOR -eq 0 ]]; then
		printf '\a'
	fi
	zle backward-kill-line
}
zle -N unix_line_discard
bindkey '^U' unix_line_discard

# Add xterm title precmd
function xterm_title_precmd {
	print -Pn -- '\e]2;%n@%m: %~\a'
}

# Install zsh hook to set the terminal title
if [[ "$TERM" == @(rxvt*|xterm*) ]]; then
	autoload -Uz add-zsh-hook
	add-zsh-hook -Uz precmd xterm_title_precmd
fi
