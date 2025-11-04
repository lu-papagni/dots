source "${ZDOTDIR}/utils.sh"

if [[ -v WSLENV ]]; then
  precmd() {
    # Correggi il prompt che non lampeggia dopo alcuni comandi
    printf '\e[?12h\e[?25h\e[5 q'

    # Visualizza utente e directory come titolo
    # printf '\x1b]0;%s@%s\a' "$USER" "${PWD/#$HOME/~}"
  }

  # Cambia stile del cursore in base alla modalità vi
  # NOTE: utile quando il terminale non supporta integrazione con la shell
  zle-keymap-select () {
    case $KEYMAP in
      vicmd)
        # Blocco fisso
        printf '\e[2 q'
        ;;
      viins|main)
        # Linea lampeggiante
        printf '\e[5 q'
        ;;
    esac
  }
  zle -N zle-keymap-select
  
  my-vi-replace-char() {
    # 1. Cambia il cursore in underscore per la durata del comando
    printf '\e[4 q'
  
    # 2. Esegui la funzione originale di Zsh per la sostituzione di un carattere
    zle vi-replace-chars "$@"
  
    # 3. Ripristina immediatamente il cursore a blocco della modalità comando
    printf '\e[2 q'
  }
  zle -N my-vi-replace-char
  bindkey -M vicmd r my-vi-replace-char
fi

# Mostra il meteo attuale
[[ -x ~/.local/bin/wttrin ]] && ~/.local/bin/wttrin 

# Avvia prompt istantaneo di powerlevel10k
# NOTE: mantenere vicino all'inizio del file 
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]];
then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

source "${ZDOTDIR}/env.sh"       # Variabili d'ambiente
source "${ZDOTDIR}/aliases.sh"   # Alias 

# zinit
## Scarica zinit se non è già installato
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
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls -1 -p -A --color=always $realpath'
zstyle ':fzf-tab:complete:cd:*' fzf-min-height 10
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

## Accetta completamento automatico
bindkey '^ ' autosuggest-accept

# Inizializza fzf
command -v 'fzf' > /dev/null && eval "$(fzf --zsh)"

# Carica il profilo del prompt
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
