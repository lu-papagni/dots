function _FetchSysInfo() {
  /usr/bin/fastfetch -c "$HOME/.config/fastfetch/$1.jsonc"
}

_FetchSysInfo "small.ascii"

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Variabili d'ambiente
## Generali
export PATH=$PATH:/home/luca/.spicetify
export EDITOR="nvim"

## java
export JAVA_HOME='/usr/lib/jvm/java-17-openjdk'
export PATH="$JAVA_HOME/bin:$PATH"

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
export ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share/}/zinit/zinit.git"

## bat pager
export BAT_THEME="base16"

# Alias
function vencord() {
  local url="https://raw.githubusercontent.com/Vendicated/VencordInstaller/main/install.sh" 
  local script="$(mktemp)"
  curl -sS --progress-bar "$url" > "$script"
  sh "$script"
}
alias ls="/usr/bin/lsd"
alias ll="ls -la"
alias la="ls -A"
alias tree="/usr/bin/lsd --tree"
alias vim="nvim"
alias prune-orphans="pacman -Qdtq | sudo pacman -Rns -"
alias rmhistory="cat /dev/null > ~/.zsh_history"
if [[ $(cat '/sys/class/dmi/id/product_version' | grep -ic 'ThinkPad') ]] then
  alias fastfetch="_FetchSysInfo thinkpad-big"
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
zinit light Aloxaf/fzf-tab                              # Usa fzf con i suggerimenti
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
eval "$(fzf --zsh)"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
