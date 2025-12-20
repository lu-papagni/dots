alias la='ls -A'
alias ll='ls -la'
alias ls='ls -p --color=auto'
alias opencode=~/.local/bin/opencode-wrapper
alias tree='tree -C'
alias vim='nvim'
alias zsh-config="$EDITOR ${ZDOTDIR:-$HOME/.zshrc}"
alias zsh-reload="source ${ZDOTDIR:-$HOME}/.zshrc"

if [[ -v WSLENV ]]; then
	alias powershell="/mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe"
	alias pwsh="/mnt/c/Program\ Files/PowerShell/7/pwsh.exe"
	alias explorer="/mnt/c/Windows/explorer.exe"
fi

# Alias specifici per Debian
if [[ -r /etc/issue ]] && [[ $(grep -ic 'debian' /etc/issue) -ge 1 ]]; then
  alias bat='batcat'
fi

