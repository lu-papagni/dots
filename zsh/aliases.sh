alias la='ls -A'
alias ll='ls -la'
alias ls='ls -p --color=auto'
alias opencode=~/.local/bin/opencode-wrapper
alias tree='tree -C'
alias vim='nvim'
alias zsh-config="$EDITOR ${ZDOTDIR:-$HOME/.zshrc}"
alias zsh-reload="source ${ZDOTDIR:-$HOME}/.zshrc"

# Alias specifici per Debian
if [[ -r /etc/issue ]] && [[ $(grep -ic 'debian' /etc/issue) -ge 1 ]]; then
  alias bat='batcat'
fi

