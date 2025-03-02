export EDITOR='nvim'

# Java
# export JAVA_HOME='/usr/lib/jvm/java-17-openjdk'
# export PATH="$JAVA_HOME/bin:$PATH"

# Moduli Python
PATH="$PATH:$HOME/.local/bin"

# Spicetify
PATH="$PATH:$HOME/.spicetify"

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
export BAT_THEME='base16'

# fzf
export FZF_DEFAULT_OPTS='--multi'

# WSL
if [[ -v WSLENV ]]; then
  export WIN_HOME="/mnt/c/Users/$(whoami)"
  export WIN_DOCUMENTS="$WIN_HOME/Documents"
  export WIN_DOWNLOADS="$WIN_HOME/Downloads"
fi

export PATH
