#!/usr/bin/env bash

source "./fmt.sh"

if [[ ! -v __DEFINE_ASSERT ]]; then
  __DEFINE_ASSERT=true

  AssertPackagesInstalled() {
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
