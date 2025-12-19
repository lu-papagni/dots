export EDITOR='nvim'

export PATH="$(printf '%s:' \
	"$HOME/.local/bin" \
	"$HOME/.spicetify" \
	"$HOME/.local/share/bob/nvim-bin" \
	"$HOME/.bun/bin" \
	"$HOME/.cache/.bun/bin" \
)${PATH}"

# man
export LESS_TERMCAP_mb=$'\e[1;34m'     # begin bold
export LESS_TERMCAP_md=$'\e[1;33m'     # begin blink
export LESS_TERMCAP_so=$'\e[01;44;30m' # begin reverse video
export LESS_TERMCAP_us=$'\e[01;37m'    # begin underline
export LESS_TERMCAP_me=$'\e[0m'        # reset bold/blink
export LESS_TERMCAP_se=$'\e[0m'        # reset reverse video
export LESS_TERMCAP_ue=$'\e[0m'        # reset underline
export GROFF_NO_SGR=1                  # for konsole and gnome-terminal
export MANPAGER='less -siM +Gg'

# zinit
export ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# bat pager
export BAT_THEME='base16'

# fzf
export FZF_DEFAULT_OPTS='--multi'
