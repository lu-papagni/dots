function __install_repair_vencord() {
  local -r url="https://raw.githubusercontent.com/Vendicated/VencordInstaller/main/install.sh" 
  local -r script="$(mktemp)"
  curl -sS --progress-bar "$url" > "$script"
  sh "$script"
}

function __install_neovim_deb() {
  local -r url='https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz'
  local -r filename='/tmp/nvim.tar.gz'
  curl -L "$url" -o "$filename"
  sudo tar -xzf "$filename" --strip-components=1 --overwrite -C '/usr'
}

alias ls='/usr/bin/lsd'
alias ll='ls -la'
alias la='ls -A'
alias tree='/usr/bin/lsd --tree'
alias vim='nvim'
alias pacman-prune-orphans='pacman -Qdtq | sudo pacman -Rns -'
alias history-clear='cat /dev/null > ~/.zsh_history'
alias vencord='__install_repair_vencord'
alias vim-update-deb='__install_neovim_deb'
alias zsh-reload="source ${ZDOTDIR:-$HOME}/.zshrc"
alias zsh-config="$EDITOR ${ZDOTDIR:-$HOME/.zshrc}"

if __get_computer_model 'ThinkPad'; then
  alias fastfetch='__fetch_system_info thinkpad-big'
fi

# Alias specifici per Debian
if __get_os_name 'Debian'; then
  alias bat='batcat'
fi

