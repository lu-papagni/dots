[[ -v XDG_CONFIG_HOME ]] || export XDG_CONFIG_HOME="$HOME/.config"

# Node version manager
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

export TMUX_TMPDIR=/tmp
if [[ -v WSLENV ]]; then
  if [[ ! -L "$HOME/.local/bin/x-www-browser" ]]; then
    for browser_exe in \
      '/mnt/c/Program Files/BraveSoftware/Brave-Browser/Application/brave.exe' \
      '/mnt/c/Program Files/Google/Chrome/Application/chrome.exe' \
      '/mnt/c/Program Files/Mozilla Firefox/firefox.exe' \
      '/mnt/c/Program Files (x86)/Microsoft/Edge/Application/msedge.exe'
    do
      if [[ -x "$browser_exe" ]]; then
        mkdir -p "$HOME/.local/bin"
        ln -s "$browser_exe" "$HOME/.local/bin/x-www-browser"
        break
      fi
    done
  fi
  export BROWSER="$HOME/.local/bin/x-www-browser"
fi
