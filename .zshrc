function _FetchSysInfo() {
  /usr/bin/fastfetch -c "$HOME/.config/fastfetch/$1.jsonc"
}

function _IsWin32() {
  grep -i 'microsoft' '/proc/sys/kernel/osrelease' > /dev/null
  return $?
}

function _HardwareNameIs() {
  local -r product='/sys/class/dmi/id/product_version'

  if [[ -f "$product" && -n "$1" ]] then
    if [[ $(cat "$product" | grep -ic "$1") -gt 0 ]] then
      return 0
    fi
  fi

  return 1
}

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

_FetchSysInfo "small.ascii"

precmd() {
  # Correggi il prompt che non lampeggia dopo alcuni comandi
  printf '\x1b[ q'
}

# Avvia prompt istantaneo di powerlevel10k
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Variabili d'ambiente
## Generali
PATH="$PATH:$HOME/.spicetify"
export EDITOR="nvim"

## Java
# export JAVA_HOME='/usr/lib/jvm/java-17-openjdk'
# export PATH="$JAVA_HOME/bin:$PATH"

## Moduli Python
PATH="$PATH:$HOME/.local/bin"

## man
export LESS_TERMCAP_mb=$'\e[1;34m'     # begin bold
export LESS_TERMCAP_md=$'\e[1;33m'     # begin blink
export LESS_TERMCAP_so=$'\e[01;44;30m' # begin reverse video
export LESS_TERMCAP_us=$'\e[01;37m'    # begin underline
export LESS_TERMCAP_me=$'\e[0m'        # reset bold/blink
export LESS_TERMCAP_se=$'\e[0m'        # reset reverse video
export LESS_TERMCAP_ue=$'\e[0m'        # reset underline
export GROFF_NO_SGR=1                  # for konsole and gnome-terminal
export MANPAGER='less -siM +Gg'

## zinit
export ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

## bat pager
export BAT_THEME="base16"

export PATH

## WSL
if _IsWin32; then
  export WIN_HOME="/mnt/c/Users/$(whoami)"
  export WIN_DOCUMENTS="$WIN_HOME/Documents"
  export WIN_DOWNLOADS="$WIN_HOME/Downloads"
fi

# Alias
alias ls="/usr/bin/lsd"
alias ll="ls -la"
alias la="ls -A"
alias tree="/usr/bin/lsd --tree"
alias vim="nvim"
alias pacman-prune-orphans="pacman -Qdtq | sudo pacman -Rns -"
alias rmhistory="cat /dev/null > ~/.zsh_history"
alias vencord='_InstallRepairVencord'
alias deb-install-vim='_InstallNeovimDeb'

if _HardwareNameIs 'ThinkPad'; then
  alias fastfetch="_FetchSysInfo thinkpad-big"
fi

if _IsWin32; then
  command -v 'batcat' > /dev/null && alias bat='batcat'
fi

# zinit
## Scarica Zinit se non è già installato
if [ ! -d "$ZINIT_HOME" ]; then
  mkdir -p "$(dirname $ZINIT_HOME)"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

## Avvia Zinit
source "${ZINIT_HOME}/zinit.zsh"

## Estensioni
zinit ice depth=1; zinit light romkatv/powerlevel10k    # Prompt
zinit light zsh-users/zsh-syntax-highlighting           # Evidenzia sintassi dei comandi
zinit light zsh-users/zsh-completions                   # Suggerimenti
zinit light zsh-users/zsh-autosuggestions               # Autocompletamento
zinit light Aloxaf/fzf-tab                              # Filtra i suggerimenti con fzf
zinit snippet OMZP::sudo                                # Premi ESC x2 per inserire sudo all'inizio
zinit snippet OMZP::command-not-found                   # Se provi ad eseguire un programma che non
                                                        # esiste suggerisce di installarlo

### Suggerimenti
autoload -Uz compinit && compinit                       # Abilita estensione
zinit cdreplay -p                                       # Abilita cache
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'  # Abilita case insensitive
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}" # Suggerimenti colorati
zstyle ':completion:*' menu no
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':fzf-tab:complete:cd:*' fzf-preview '/usr/bin/lsd -A $realpath'
zstyle ':fzf-tab:complete:systemctl-*:*' fzf-preview 'SYSTEMD_COLORS=1 systemctl status $word'

### Autocompletamento
HISTSIZE=1000             # Lunghezza max cronologia
HISTFILE=~/.zsh_history   # File cronologia
SAVEHIST=$HISTSIZE        # Max righe da salvare
HISTDUP=erase             # Ignora duplicati
setopt hist_ignore_dups
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_find_no_dups
setopt hist_ignore_space
setopt share_history

# Globbing
setopt extendedglob

# Keybindings
## Imposta modalità VIM
bindkey -v

## Cronologia
bindkey '^k' history-search-backward
bindkey '^j' history-search-forward

# Inizializza fzf
export FZF_DEFAULT_OPTS='--multi'
eval "$(fzf --zsh)"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
