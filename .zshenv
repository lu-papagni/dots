[[ -v XDG_CONFIG_HOME ]] || export XDG_CONFIG_HOME="$HOME/.config"

# Node version manager
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

export PATH="$(printf '%s:' \
	"$HOME/.local/bin" \
	"$HOME/.spicetify" \
	"$HOME/.local/share/bob/nvim-bin" \
	"$HOME/.bun/bin" \
	"$HOME/.cache/.bun/bin" \
)${PATH}"
