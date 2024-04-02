# source "./hyprland.sh"

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
DISABLE_AUTO_TITLE=true
DISABLE_LS_COLORS=true
#export QT_QPA_PLATFORMTHEME="qt5ct"

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
alias tree="/usr/bin/lsd --tree"
# alias prime_run="__NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia"
alias vencord="sh -c $(curl -sS https://raw.githubusercontent.com/Vendicated/VencordInstaller/main/install.sh)"
alias prune-orphans="pacman -Qdtq | sudo pacman -Rns -"
alias rmhistory="cat /dev/null > ~/.zsh_history"
alias dotfiles="cd ~/.dotfiles/ && nvim ."

# Inizializza zsh e powerlevel10k
source $ZSH/oh-my-zsh.sh
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
