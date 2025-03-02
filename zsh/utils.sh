function _FetchSysInfo() {
  local -r fetch="$(command -v fastfetch | head -n 1)"
  eval "$fetch -c "$HOME/.config/fastfetch/$1.jsonc""
}

function _GetComputerModel() {
  local -r product='/sys/class/dmi/id/product_version'

  if [[ -f "$product" && -n "$1" ]] then
    if [[ $(cat "$product" | grep -ic "$1") -gt 0 ]] then
      return 0
    fi
  fi

  return 1
}
