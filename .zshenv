export ZDOTDIR=~/.config/zsh
export FETCH_TOOL=/usr/bin/fastfetch
[[ -v XDG_CONFIG_HOME ]] || export XDG_CONFIG_HOME="$HOME/.config"
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
export TMUX_TMPDIR=/tmp
