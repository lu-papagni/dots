function _InstallRepairVencord() {
  local -r url="https://raw.githubusercontent.com/Vendicated/VencordInstaller/main/install.sh" 
  local -r script="$(mktemp)"
  curl -sS --progress-bar "$url" > "$script"
  sh "$script"
}

function _InstallNeovimDeb() {
  local -r url='https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz'
  local -r filename='/tmp/nvim.tar.gz'
  curl -L "$url" -o "$filename"
  sudo tar -xzf "$filename" --strip-components=1 --overwrite -C '/usr'
}

alias ls="/usr/bin/lsd"
alias ll="ls -la"
alias la="ls -A"
alias tree="/usr/bin/lsd --tree"
alias vim="nvim"
alias pacman-prune-orphans="pacman -Qdtq | sudo pacman -Rns -"
alias rmhistory="cat /dev/null > ~/.zsh_history"
alias vencord='_InstallRepairVencord'
alias vim-update-deb='_InstallNeovimDeb'

if _GetComputerModel 'ThinkPad'; then
  alias fastfetch="_FetchSysInfo thinkpad-big"
fi

if [[ $(grep -ic 'debian' '/etc/issue') -ge 1 ]]; then
  alias bat='batcat'
fi

