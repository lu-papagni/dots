#!/usr/bin/env bash

[[ -v __DEFINE_FMT ]] && return
readonly __DEFINE_FMT

# Generale
readonly __FMT_PREFIX="\e["            # Prefisso di ogni codice escape
readonly __FMT_OFF="${__FMT_PREFIX}0m" # Reset

# Effetti
readonly __FMT_INVERT="${__FMT_PREFIX}7m"

# Colori
readonly __FMT_MAGENTA="${__FMT_PREFIX}35m"
readonly __FMT_RED="${__FMT_PREFIX}31m"
readonly __FMT_YELLOW="${__FMT_PREFIX}33m"
readonly __FMT_GREEN="${__FMT_PREFIX}32m"
readonly __FMT_GRAY="${__FMT_PREFIX}90m"
readonly __FMT_BLUE="${__FMT_PREFIX}34m"

# Simboli
readonly __FMT_SEPR="${__FMT_GRAY}::${__FMT_OFF}" # Separatore `::` di colore grigio

# Stampa una riga di log, info, errore
function Log() {
  local msg
  local pre

  if [[ $SETUP_OUTPUT_OFF -eq 1 ]]; then
    case "$1" in
    -e | --error)
      msg="$2"
      pre="${__FMT_RED}[ERRORE]"
      ;;
    -i | --info)
      msg="$2"
      pre="${__FMT_YELLOW}[INFO]"
      ;;
    *)
      msg="$1"
      pre="${__FMT_GREEN}[LOG]"
      ;;
    esac

    echo -e "${pre}${__FMT_OFF} ${__FMT_SEPR} $msg"
  fi
}

# Stampa una riga evidenziandola
function Highlight() echo "$__FMT_GRAY$__FMT_INVERT$1$__FMT_OFF"
