#!/usr/bin/env bash

source "$(pwd)/utils/fmt.sh"
source "$(pwd)/utils/assert.sh"

# ███████╗██████╗  ██████╗ ████████╗██╗███████╗██╗   ██╗
# ██╔════╝██╔══██╗██╔═══██╗╚══██╔══╝██║██╔════╝╚██╗ ██╔╝
# ███████╗██████╔╝██║   ██║   ██║   ██║█████╗   ╚████╔╝
# ╚════██║██╔═══╝ ██║   ██║   ██║   ██║██╔══╝    ╚██╔╝
# ███████║██║     ╚██████╔╝   ██║   ██║██║        ██║
# ╚══════╝╚═╝      ╚═════╝    ╚═╝   ╚═╝╚═╝        ╚═╝

[[ -v __DEFINE_SPICETIFY ]] && return
readonly __DEFINE_SPICETIFY

function SpicetifyFolderOwnership() {
  AssertExecutable "flatpak" "sed" "grep"

  if [[ $? -eq 0 ]]; then
    while getopts 'h' opt; do
      case "$opt" in
      h)
        echo "Concede i privilegi di lettura e scrittura sulle cartelle protette" \
          "della versione Flatpak di Spotify."
        echo "Non ammette parametri.\n"
        return 0
        ;;
      esac
    done

    local installations="$(flatpak --installations)"
    local ref="$(flatpak info com.spotify.Client | grep "Ref: " | sed "s/^.*: //")"
    local files_path="$installations/$ref/active/files/extra/share/spotify"

    sudo chmod a+wr "$files_path"
    sudo chmod a+wr -R "$files_path/Apps"

    return 0
  else
    return 1
  fi
}

# PARAMETRI
# t (theme): lista di nomi validi di temi.
# f (folder): fornisce a spicetify i permessi di lettura e scrittura
#             sulle cartelle richieste dalla wiki.
function SpicetifyConfig() {
  AssertExecutable "flatpak" "wget" "curl" "grep"

  if [[ $? -eq 0 ]]; then
    local themes=()

    while getopts 't:h' opt; do
      case ${opt} in
      t)
        themes+=($OPTARG)
        ;;
      h)
        echo "Configura Spicetify, il software per moddare Spotify.\n"
        column "$(pwd)/help/spicetify-config.txt" -tL -s '|'
        return 0
        ;;
      ?)
        return 1
        ;;
      esac
    done

    curl -fsSL 'https://raw.githubusercontent.com/spicetify/cli/main/install.sh' | sh
    flatpak list | grep 'com.spotify.Client'

    if [[ $? -eq 0 ]]; then
      Log "Trovata installazione di Spotify. Continuo..."

      if [ ${#themes[@]} -gt 0 ]; then
        for theme in ${themes[@]}; do
          local folder="${SETUP_HOME:-$HOME}/.dotfiles/spicetify/Themes/$theme"

          Log "Installo il tema $(Highlight "$theme") per Spicetify."

          mkdir -p "$folder"
          (
            cd "$folder"
            wget -O "https://raw.githubusercontent.com/spicetify/spicetify-themes/master/$theme/color.ini" color.ini
            wget -O "https://raw.githubusercontent.com/spicetify/spicetify-themes/master/$theme/user.css" user.css
          )
        done
      else
        Log --info "Non sono trovati temi da installare."
      fi

      Log "Concessione permessi di lettura e scrittura..."
      Log --info "Perché? Vedi https://spicetify.app/docs/advanced-usage/installation#spotify-installed-from-flatpak"
      SpicetifyFolderOwnership

      Log --info "Per terminare la configurazione, avviare Spotify ed eseguire il login."
      Log --info "Successivamente, eseguire $(Highlight 'spicetify backup apply')."

      return 0

    else
      Log --error "Impossibile procedere per Spicetify."
      Log --error "Spotify non è installato sul sistema o non è in formato Flatpak."
      return 1
    fi
  fi
}
