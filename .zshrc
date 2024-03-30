# Esegui Hyprland dopo il login da tty1
if [ "$(tty)" = "/dev/tty1" ]; then
  which "Hyprland" > /dev/null
  if [ $? -eq 0 ]; then
    exec Hyprland
  else
    echo "Hyprland non installato!"
  fi
fi

fastfetch -c ~/.config/fastfetch/small.jsonc

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Variabili d'ambiente
export ZSH="$HOME/.oh-my-zsh"
export PATH=$PATH:/home/luca/.spicetify
export EDITOR='nvim'
#export QT_QPA_PLATFORMTHEME="qt5ct"
UNIVERSITY_DIR="/home/$(whoami)/OneDrive/Documenti/UNI"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
  vi-mode
)

# Alias
alias ls="/usr/bin/lsd --color always"
alias tree="ls --tree"
alias ffc="fastfetch"
alias ghidra="/home/luca/ghidra_10.2.2_PUBLIC/ghidraRun"
alias ascii_live="~/.ascii-live.sh & exit"
alias prime_run="__NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia"
# alias dotfiles="/usr/bin/git --git-dir=$HOME/.dotfiles --work-tree=$HOME"
alias vencord="sh -c $(curl -sS https://raw.githubusercontent.com/Vendicated/VencordInstaller/main/install.sh)"
alias pacrm_orphans="pacman -Qdtq | sudo pacman -Rns -"

# Inizializza zsh e powerlevel10k
source $ZSH/oh-my-zsh.sh
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
