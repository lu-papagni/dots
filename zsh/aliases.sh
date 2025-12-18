function __install_repair_vencord() {
  local -r url="https://raw.githubusercontent.com/Vendicated/VencordInstaller/main/install.sh" 
  local -r script="$(mktemp)"
  curl -sS --progress-bar "$url" > "$script"
  sh "$script"
}

alias ls='ls -p --color=auto'
alias ll='ls -la'
alias la='ls -A'
alias opencode=~/.local/bin/opencode-wrapper
alias vim='nvim'
alias pacman-prune-orphans='pacman -Qdtq | sudo pacman -Rns -'
alias history-clear='cat /dev/null > ~/.zsh_history'
alias vencord='__install_repair_vencord'
alias zsh-reload="source ${ZDOTDIR:-$HOME}/.zshrc"
alias zsh-config="$EDITOR ${ZDOTDIR:-$HOME/.zshrc}"

# Alias specifici per Debian
if __get_os_name 'Debian'; then
  alias bat='batcat'
fi

