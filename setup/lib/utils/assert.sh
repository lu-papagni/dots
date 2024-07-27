#!/usr/bin/env bash

source "$(dirname ${BASH_SOURCE[0]:-$0})/fmt.sh"

if [[ ! -v __DEFINE_ASSERT ]]; then
  __DEFINE_ASSERT=true

  AssertExecutable() {
    local missing=()

    for package in "$@"; do
      if [[ -z "$(command -v "$package")" ]]; then
        missing+=("$package")
      fi
    done

    if [[ ${#missing[@]} -gt 0 ]]; then
      PrintErr "Requisiti non soddisfatti!"

      for m in ${missing[*]}; do
        PrintErr "$m non trovato."
      done

      # almeno un eseguibile richiesto non è installato
      return 1
    fi

    # tutto ok
    return 0
  }
fi
