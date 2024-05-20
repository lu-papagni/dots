# cat ".cache/wal/sequences"    # Colori generati da Pywal

fastfetch -c "$HOME/.config/fastfetch/small.jsonc"

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Variabili d'ambiente
## Generali
export PATH=$PATH:/home/luca/.spicetify
export EDITOR="nvim"

## zinit
export ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share/}/zinit/zinit.git"

## bat pager
export BAT_THEME="base16"

# Alias
alias ls="/usr/bin/lsd"
alias tree="/usr/bin/lsd --tree"
alias vencord="sh -c \"$(curl -sS https://raw.githubusercontent.com/Vendicated/VencordInstaller/main/install.sh)\""
alias prune-orphans="pacman -Qdtq | sudo pacman -Rns -"
alias rmhistory="cat /dev/null > ~/.zsh_history"

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
setopt inc_append_history
setopt hist_ignore_space  # Ignora comandi che iniziano con spazio
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups  # Non mostrare duplicati nella ricerca

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
