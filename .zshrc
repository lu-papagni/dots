# powerlevel10k instant prompt
# NOTE: keep near top of profile
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]];
then
	source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Shell integration fixes on Windows
if [[ $(uname -r) = *microsoft-*WSL* ]]; then
	precmd() {
		# Correct prompt not blinking
		printf '\e[?12h\e[?25h\e[5 q'
	}

	# Cursor style per VI mode
	zle-keymap-select () {
		case $KEYMAP in
			vicmd)
				printf '\e[2 q'		# Block
				;;
			viins|main)
				printf '\e[5 q'		# Beam - blinking
				;;
		esac
	}
	zle -N zle-keymap-select
	
	# Change cursor into underscore for VI replace mode
	my-vi-replace-char() {
		printf '\e[4 q'
		zle vi-replace-chars "$@"
		printf '\e[2 q'
	}
	zle -N my-vi-replace-char
	bindkey -M vicmd r my-vi-replace-char
fi

# Enviroment
export EDITOR='nvim'
export BAT_THEME='base16'
export MANROFFOPT='-c'
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export FZF_DEFAULT_OPTS='--multi'
export TMUX_TMPDIR=/tmp
if [[ -x ~/.local/bin/wsl-browser ]]; then
	export BROWSER=~/.local/bin/wsl-browser
fi

# Aliases
alias gc='git commit'
alias gl='git log'
alias gs='git status'
alias la='ls -A'
alias ll='ls -la'
alias ls='ls -p --color=auto'
alias opencode=~/.local/bin/opencode-wrapper
alias tree='tree -C'
alias vim='nvim'; hash -d vimrc=~/.config/nvim

if [[ $(uname -r) = *microsoft-*WSL* ]]; then
	alias explorer="/mnt/c/Windows/explorer.exe"
	alias powershell="/mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe"
	alias pwsh="/mnt/c/Program\ Files/PowerShell/7/pwsh.exe"
fi

if [[ -r /etc/issue ]] && [[ $(grep -ic 'debian' /etc/issue) -ge 1 ]]; then
  alias bat='batcat'
fi

# Download plugin manager if not installed
export ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [ ! -d "$ZINIT_HOME" ]; then
	mkdir -p "$(dirname $ZINIT_HOME)"
	git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi
source "${ZINIT_HOME}/zinit.zsh"

# Extensions
zinit ice depth=1; zinit light romkatv/powerlevel10k
zinit ice depth=1; zinit light zsh-users/zsh-syntax-highlighting
zinit ice depth=1; zinit light zsh-users/zsh-completions
zinit ice depth=1; zinit light zsh-users/zsh-autosuggestions
zinit ice depth=1; zinit light Aloxaf/fzf-tab
zinit snippet OMZP::sudo
zinit snippet OMZP::command-not-found

autoload -Uz edit-command-line && zle -N edit-command-line
autoload -Uz compinit && compinit

# Suggestions
zinit cdreplay -p																				# Abilita cache
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'	# Abilita case insensitive
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}" # Suggerimenti colorati
zstyle ':completion:*' menu no
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls -1 -p -A --color=always $realpath'
zstyle ':fzf-tab:complete:cd:*' fzf-min-height 10
zstyle ':fzf-tab:complete:systemctl-*:*' fzf-preview 'SYSTEMD_COLORS=1 systemctl status $word'

# Autocomplete
HISTSIZE=1000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt hist_ignore_dups
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_find_no_dups
setopt hist_ignore_space
setopt share_history

# Keybindings
toggle-foreground-job() {
	fg 2>/dev/null
	[[ $? -eq 0 ]] && zle accept-line
}
zle -N toggle-foreground-job

bindkey -v
bindkey '^k' history-search-backward
bindkey '^j' history-search-forward
bindkey '^ ' autosuggest-accept
bindkey '^x^e' edit-command-line
bindkey '^_' undo
bindkey '^z' toggle-foreground-job

# Initialize fzf
command -v 'fzf' > /dev/null && eval "$(fzf --zsh)"

[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

