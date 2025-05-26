# Esegue il fetch delle informazioni di sistema usando il
# FETCH_TOOL specificato.
#
# Parametri:
# 1) Nome della configurazione
function __fetch_system_info() {
  local fetch_cmd="$(command -v $FETCH_TOOL)"

  [[ -n "$fetch_cmd" && -n "$1" ]] || return -1

  eval "$fetch_cmd" -c "${XDG_CONFIG_HOME}/${fetch_cmd##*/}/${1}.jsonc"
}

# Ottiene il nome del modello di PC in uso.
function __get_computer_model() {
  [[ -n "$1" ]] || return -1

  local model=

  if [[ -v WSLENV ]]; then
    # Windows
    local pwsh=
    local -r pwsh_version_cmd='(Get-CimInstance -ClassName Win32_ComputerSystemProduct).Version'

    if command -v pwsh.exe &> /dev/null; then
      pwsh='pwsh.exe'
    else
      pwsh='powershell.exe'
    fi

    model="$("$pwsh" -NoProfile -NonInteractive -NoLogo -Command "$pwsh_version_cmd")"
  else
    # UNIX
    local -r product_info='/sys/class/dmi/id/product_version'
    [[ -r "$product_info" ]] && model="$(cat "$product_info")"
  fi

  # Il modello cercato è presente
  [[ $(printf "$model" | grep -ic "$1") -gt 0 ]]

  return $?
}

# Verifica il nome del sistema Linux in uso
#
# Parametri:
# 1) Nome da verificare
function __get_os_name() {
  [[ -r '/etc/issue' ]] || return -1
  [[ $(grep -ic "$1" '/etc/issue') -ge 1 ]]

  return $?
}
