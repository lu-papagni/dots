#!/usr/bin/env bash

source "utils/fmt.sh"
source "utils/assert.sh"

# ██╗     ██╗███╗   ██╗██╗  ██╗██╗███╗   ██╗ ██████╗
# ██║     ██║████╗  ██║██║ ██╔╝██║████╗  ██║██╔════╝
# ██║     ██║██╔██╗ ██║█████╔╝ ██║██╔██╗ ██║██║  ███╗
# ██║     ██║██║╚██╗██║██╔═██╗ ██║██║╚██╗██║██║   ██║
# ███████╗██║██║ ╚████║██║  ██╗██║██║ ╚████║╚██████╔╝
# ╚══════╝╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝ ╚═════╝

[[ -v __DEFINE_LINKFILES ]] && return
readonly __DEFINE_LINKFILES

# Fatta in casa, 100% naturale
function LinkDotfiles() {
  AssertExecutable "grep" "xargs" "find"

  if [[ $? -eq 0 ]]; then
    local source_dir="$(pwd)"
    local filter_file="${SETUP_HOME:-$HOME}/.dotfiles/setup/.setup-ignore-link"

    while getopts 's:f:h' opt; do
      case $opt in
      f)
        filter_file="$OPTARG"
        ;;
      s)
        source_dir="$OPTARG"
        ;;
      h)
        echo "Esegue il link simbolico di file e directory.\n"
        column "$(pwd)/help/link-dotfiles.txt" -tL -s '|'
        return 0
        ;;
      ?)
        Log --error "Sintassi di LinkDotFiles errata."
        return 1
        ;;
      esac
    done

    mkdir -p "$HOME/.config"

    if [[ ! -r "$filter_file" ]]; then
      Log --error "Il file filtro $(Highlight "$filter_file") non esiste."
      return 1
    fi

    # Link simbolico directory
    find "$source_dir" -mindepth 1 -maxdepth 1 -type d | grep -vGf "$filter_file" | xargs -I{} ln -s {} "$HOME/.config"

    # Link simbolico file
    find "$source_dir" -mindepth 1 -maxdepth 1 -type f | grep -vGf "$filter_file" | xargs -I{} ln -s {} "$HOME"
  fi
}

function UnlinkDotfiles() {
  AssertExecutable "grep" "xargs" "find"

  if [[ $? -eq 0 ]]; then
    local filter_file="${SETUP_HOME:-$HOME}/.dotfiles/setup/.setup-ignore-link"
    local source_dir="${SETUP_HOME:-$HOME}/.dotfiles"

    while getopts 'd:f:h' opt; do
      case ${opt} in
      f)
        filter_file="$OPTARG"
        ;;
      d)
        source_dir="$OPTARG"
        ;;
      h)
        echo "Ripristina il link simbolico di file e directory."
        column "$(pwd)/help/unlink-dotfiles.txt" -tL -s '|'
        return 0
        ;;
      esac
    done

    Log "Rimuovo i collegamenti simbolici..."

    # Rimozione cartelle
    find "$HOME/.config" -mindepth 1 -maxdepth 1 -type l | grep -G "$(
      find "$source_dir" -mindepth 1 -maxdepth 1 -type d | xargs -I{} basename {}
    )" | xargs rm

    # Rimozione file
    find "$HOME" -mindepth 1 -maxdepth 1 -type l | grep -G "$(
      find "$source_dir" -mindepth 1 -maxdepth 1 -type f | xargs -I{} basename {}
    )" | xargs rm

    Log "... fine rimozione collegamenti"
  fi
}

# Versione che usa GNU Stow - non funziona :(
function StowDotfiles() {
  AssertExecutable "stow"

  if [[ $? -eq 0 ]]; then
    local TARGET_DIR="$HOME/.config"
    local DRY_RUN=""
    local source_dir="$SETUP_DOTS_DIR"

    while getopts 't:d:n' opt; do
      case ${opt} in
      t)
        TARGET_DIR="$OPTARG"
        ;;
      d)
        source_dir="$OPTARG"
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
      Log --error "Creazione della directory $(Highlight "$TARGET_DIR") fallita."
      return 1
    fi

    return 0
  else
    return 1
  fi
}
