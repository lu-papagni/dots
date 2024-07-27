#!/usr/bin/env bash

source "$(dirname ${BASH_SOURCE[0]:-$0})/utils/assert.sh"

function KWalletSetup() {
  AssertExecutable "ksshaskpass" "which"

  while getopts 'h' opt; do
    case "$opt" in
    h)
      echo "Configura KWallet per essere compatibile con vari software.\n"
      return 0
      ;;
    esac
  done

  if [[ $? -eq 0 ]]; then
    mkdir -p "$HOME/.config/environment.d"
    echo "GIT_ASKPASS=$(which ksshaskpass)" >"$HOME/.config/environment.d/git_askpass.conf"
  fi
}
