if [ ! -v __DEFINE_FMT ]; then
  __DEFINE_FMT=true

  # Codici per output colorato
  __FMT_PREFIX="\e["
  __FMT_OFF="$__FMT_PREFIX""0m"
  __FMT_MAGENTA="$__FMT_PREFIX""35m"
  __FMT_RED="$__FMT_PREFIX""31m"
  __FMT_YELLOW="$__FMT_PREFIX""33m"
  __FMT_GREEN="$__FMT_PREFIX""32m"
  __FMT_GRAY="$__FMT_PREFIX""90m"

  # Stampa una riga di log
  function PrintLog() {
    local STR="$1"
    echo -e "$__FMT_MAGENTA[SETUP]$__FMT_OFF $STR"
  }

  # Stampa una riga di errore
  function PrintErr() {
    local STR="$1"
    echo -e "$__FMT_RED[ERROR] $(PrintLog "$STR")"
  }

  # Stampa una riga di informazione/warning
  function PrintInfo() {
    local STR="$1"
    echo -e "$__FMT_YELLOW[INFO] $(PrintLog "$STR")"
  }

  # Stampa una riga che contiene un comando
  function PrintExample() {
    local STR="$1"
    echo -e "$__FMT_GRAY$STR$__FMT_OFF"
  }
fi
