#!/usr/bin/env bash

function KWalletSetup() {
  AssertPackagesInstalled "ksshaskpass"

  if [[ $? -eq 0 ]]; then
    mkdir -p ~/.config/environment.d
    echo "GIT_ASKPASS=/usr/bin/ksshaskpass" >"$HOME/.config/environment.d/git_askpass.conf"
  fi
}
