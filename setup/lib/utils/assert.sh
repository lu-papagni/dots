#!/usr/bin/env bash

source "$(dirname ${BASH_SOURCE[0]:-$0})/fmt.sh"

[[ -v __DEFINE_ASSERT ]] && return
readonly __DEFINE_ASSERT

function AssertExecutable() {
  local count=0
  local -r caller="${FUNCNAME[1]:-${funcstack[2]}}"

  for package in "$@"; do
    if ! command -v "$package" &>/dev/null; then
      Log --error "Nella funzione $__FMT_RED$caller$__FMT_OFF: comando richiesto $__FMT_GREEN$package$__FMT_OFF non disponibile."
      ((count += 1))
    fi
  done

  # almeno un eseguibile richiesto non è installato
  if [[ $count -gt 0 ]]; then
    Log --error "Nella funzione $__FMT_RED$caller$__FMT_OFF: $count requisito/i non soddisfatti!"
    return 1
  fi

  # tutto ok
  return 0
}
