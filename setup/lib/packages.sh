#!/usr/bin/env bash

source "$(dirname ${BASH_SOURCE[0]:-$0})/utils/fmt.sh"
source "$(dirname ${BASH_SOURCE[0]:-$0})/utils/assert.sh"

# ██████╗  █████╗  ██████╗██╗  ██╗ █████╗  ██████╗ ███████╗███████╗
# ██╔══██╗██╔══██╗██╔════╝██║ ██╔╝██╔══██╗██╔════╝ ██╔════╝██╔════╝
# ██████╔╝███████║██║     █████╔╝ ███████║██║  ███╗█████╗  ███████╗
# ██╔═══╝ ██╔══██║██║     ██╔═██╗ ██╔══██║██║   ██║██╔══╝  ╚════██║
# ██║     ██║  ██║╚██████╗██║  ██╗██║  ██║╚██████╔╝███████╗███████║
# ╚═╝     ╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝ ╚══════╝╚══════╝

if [ ! -v __DEFINE_PACKAGEINST ]; then
  __DEFINE_PACKAGEINST=true

  # PARAMETRI
  # -s (sources): lista delle fonti di installazione
  function InstallPackages() {
    AssertExecutable "cat"

    if [[ $? -eq 0 ]]; then
      local SOURCES=

      while getopts 's:h' opt; do
        case ${opt} in
        s)
          SOURCES=($OPTARG)
          ;;
        h)
          column "$(dirname ${BASH_SOURCE[0]:-$0})/help/install-packages.txt" -tL -s '|'
          return 0
          ;;
        ?)
          PrintErr "Sintassi di InstallPackages errata."
          return 1
          ;;
        esac
      done

      shift $(($OPTIND - 1))

      # Controllo se sono stati forniti i parametri
      if [[ -z $SOURCES ]]; then
        PrintErr "Installazione pacchetti: non sono state forniti i parametri."
        return 1
      fi

      # Parsing del file
      for source in ${SOURCES[*]}; do

        local PGK_MANAGER=""
        local INSTALL_CMD=""
        local PACKAGES=()
        local PRIVILEGE=""
        local SKIP_CONFIRM_CMD=""

        PrintLog "Lettura lista dei pacchetti (fonte '$source')..."

        for line in $(cat "sources/$source.txt"); do
          if [[ ! $line == !* ]]; then
            PACKAGES+=("$line")
          else
            PKG_MANAGER="${line#*\!}" # Scarta tutto fino al punto esclamativo
          fi
        done

        case "$PKG_MANAGER" in
        "yay")
          INSTALL_CMD="-S"
          SKIP_CONFIRM_CMD="--noconfirm"
          ;;
        "flatpak")
          INSTALL_CMD="install"
          PRIVILEGE="sudo"
          SKIP_CONFIRM_CMD="--assumeyes"
          ;;
        *)
          PrintErr "'$PKG_MANAGER' non supportato."
          return 1
          ;;
        esac

        AssertExecutable "$PKG_MANAGER"

        if [[ $? -eq 0 ]]; then
          PrintLog "Installazione pacchetti (fonte $(PrintExample "$source"))..."

          # Composizione del comando per installare i pacchetti
          $PRIVILEGE $PKG_MANAGER $INSTALL_CMD $SKIP_CONFIRM_CMD $(
            for pkg in ${PACKAGES[*]}; do
              echo -n "$pkg "
            done
          )
        fi

      done # Fine parsing

      PrintLog "... fine installazione pacchetti."

    fi
  }
fi
