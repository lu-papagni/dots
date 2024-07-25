#!/usr/bin/env bash

source "./utils/fmt.sh"
source './utils/path.sh'

# ██╗     ██╗███╗   ██╗██╗  ██╗██╗███╗   ██╗ ██████╗
# ██║     ██║████╗  ██║██║ ██╔╝██║████╗  ██║██╔════╝
# ██║     ██║██╔██╗ ██║█████╔╝ ██║██╔██╗ ██║██║  ███╗
# ██║     ██║██║╚██╗██║██╔═██╗ ██║██║╚██╗██║██║   ██║
# ███████╗██║██║ ╚████║██║  ██╗██║██║ ╚████║╚██████╔╝
# ╚══════╝╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝ ╚═════╝

if [ ! -v __DEFINE_LINKFILES ]; then
  __DEFINE_LINKFILES=true

  # Versione a chilometro zero fatta in casa (99% crasha)
  function LinkDotfiles() {
    AssertPackagesInstalled "find" "xargs"

    if [[ $? -eq 0 ]]; then
      local EXCLUDE_FROM_LINK=
      local TARGET_DIR=
      local DOTS_DIR="$(GetDotsDir)"

      while getopts 'e:' opt; do
        case ${opt} in
        e)
          EXCLUDE_FROM_LINK=($OPTARG)
          ;;
        t)
          TARGET_DIR="$OPTARG"
          ;;
        ?)
          PrintErr "Sintassi di LinkDotFiles errata."
          exit 1
          ;;
        esac
      done

      shift $(($OPTIND - 1))

      # Valore di default per la directory target
      if [[ -z $TARGET_DIR ]]; then
        TARGET_DIR="$HOME/.config/"
      fi

      [ -d "$HOME/.config" ] || mkdir "$HOME/.config"

      PrintLog "Link simbolico delle directory..."

      # Soft link dotfiles
      find $DOTS_DIR -maxdepth 1 -type d -not -path "$DOTS_DIR/.*" $(
        for dir in ${EXCLUDE_FROM_LINK[*]}; do
          echo -n "-and -not -path "$DOTS_DIR/$dir" "
        done
      ) |
        xargs -I{} ln -s {} "$TARGET_DIR"

      PrintLog "... fine collegamento simbolico."

    fi
  }

  # Nuova versione che fa uso di GNU Stow
  function StowDotfiles() {
    AssertPackagesInstalled "stow"

    if [[ $? -eq 0 ]]; then
      local TARGET_DIR="$HOME/.config"
      local DRY_RUN=""

      while getopts 't:n' opt; do
        case ${opt} in
        t)
          TARGET_DIR="$OPTARG"
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
        stow "$DRY_RUN -v --dir="$(GetDotsDir)" --target="$TARGET_DIR""
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
