#!/usr/bin/env bash

source "$(dirname ${BASH_SOURCE[0]:-$0})/utils/fmt.sh"
source "$(dirname ${BASH_SOURCE[0]:-$0})/utils/assert.sh"

# ██╗     ██╗███╗   ██╗██╗  ██╗██╗███╗   ██╗ ██████╗
# ██║     ██║████╗  ██║██║ ██╔╝██║████╗  ██║██╔════╝
# ██║     ██║██╔██╗ ██║█████╔╝ ██║██╔██╗ ██║██║  ███╗
# ██║     ██║██║╚██╗██║██╔═██╗ ██║██║╚██╗██║██║   ██║
# ███████╗██║██║ ╚████║██║  ██╗██║██║ ╚████║╚██████╔╝
# ╚══════╝╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝ ╚═════╝

if [ ! -v __DEFINE_LINKFILES ]; then
  __DEFINE_LINKFILES=true

  # Fatta in casa, 100% naturale
  function LinkDotfiles() {
    AssertExecutable "grep" "xargs" "find"

    if [[ $? -eq 0 ]]; then
      local SOURCE_DIR="$(pwd)"
      local FILTER_FILE="$SETUP_DOTS_DIR/setup/.setup-ignore-link"

      while getopts 's:f:h' opt; do
        case $opt in
        f)
          FILTER_FILE="$OPTARG"
          ;;
        s)
          SOURCE_DIR="$OPTARG"
          ;;
        h)
          echo "Esegue il link simbolico di file e directory.\n"
          column "$(dirname ${BASH_SOURCE[0]:-$0})/help/link-dotfiles.txt" -tL -s '|'
          return 0
          ;;
        ?)
          PrintErr "Sintassi di LinkDotFiles errata."
          return 1
          ;;
        esac
      done

      mkdir -p "$HOME/.config"

      # Link simbolico directory
      find "$SOURCE_DIR" -mindepth 1 -maxdepth 1 -type d | grep -vGf "$FILTER_FILE" | xargs -I{} ln -s {} "$HOME/.config"

      # Link simbolico file
      find "$SOURCE_DIR" -mindepth 1 -maxdepth 1 -type f | grep -vGf "$FILTER_FILE" | xargs -I{} ln -s {} "$HOME"
    fi
  }

  function UnlinkDotfiles() {
    AssertExecutable "grep" "xargs" "find"

    if [[ $? -eq 0 ]]; then
      local FILTER_FILE="$SETUP_DOTS_DIR/.setup-ignore-link"
      local SOURCE_DIR="$(pwd)"

      while getopts 's:f:h' opt; do
        case ${opt} in
        f)
          FILTER_FILE="$OPTARG"
          ;;
        s)
          SOURCE_DIR="$OPTARG"
          ;;
        h)
          echo "Ripristina il link simbolico di file e directory."
          column "$(dirname ${BASH_SOURCE[0]:-$0})/help/unlink-dotfiles.txt" -tL -s '|'
          return 0
          ;;
        esac
      done

      PrintLog "Rimuovo i collegamenti simbolici..."

      # Rimozione cartelle
      find "$HOME/.config" -mindepth 1 -maxdepth 1 -type l | grep -G "$(
        find "$SOURCE_DIR" -mindepth 1 -maxdepth 1 -type d | xargs -I{} basename {}
      )" | xargs rm

      # Rimozione file
      find "$HOME" -mindepth 1 -maxdepth 1 -type l | grep -G "$(
        find "$SOURCE_DIR" -mindepth 1 -maxdepth 1 -type f | xargs -I{} basename {}
      )" | xargs rm

      PrintLog "... fine rimozione collegamenti"
    fi
  }

  # Versione che usa GNU Stow - non funziona :(
  function StowDotfiles() {
    AssertExecutable "stow"

    if [[ $? -eq 0 ]]; then
      local TARGET_DIR="$HOME/.config"
      local DRY_RUN=""
      local SOURCE_DIR="$SETUP_DOTS_DIR"

      while getopts 't:d:n' opt; do
        case ${opt} in
        t)
          TARGET_DIR="$OPTARG"
          ;;
        d)
          SOURCE_DIR="$OPTARG"
          ;;
        n)
          DRY_RUN="-n"
          ;;
        ?)
          return 1
          ;;
        esac
      done

      mkdir -p "$TARGET_DIR"

      if [[ $? -eq 0 ]]; then
        stow "$DRY_RUN" -v --dir="$SETUP_DOTS_DIR" --target="$TARGET_DIR"
      else
        PrintErr "Creazione della directory $(PrintExample "$TARGET_DIR") fallita."
        return 1
      fi

      return 0
    else
      return 1
    fi
  }
fi
