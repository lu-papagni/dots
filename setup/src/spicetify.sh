#!/usr/bin/env bash

source "./utils/fmt.sh"
source "./utils/path.sh"
source "./utils/assert.sh"

# ███████╗██████╗  ██████╗ ████████╗██╗███████╗██╗   ██╗
# ██╔════╝██╔══██╗██╔═══██╗╚══██╔══╝██║██╔════╝╚██╗ ██╔╝
# ███████╗██████╔╝██║   ██║   ██║   ██║█████╗   ╚████╔╝
# ╚════██║██╔═══╝ ██║   ██║   ██║   ██║██╔══╝    ╚██╔╝
# ███████║██║     ╚██████╔╝   ██║   ██║██║        ██║
# ╚══════╝╚═╝      ╚═════╝    ╚═╝   ╚═╝╚═╝        ╚═╝

if [ ! -v __DEFINE_SPICETIFY ]; then
  __DEFINE_SPICETIFY=true

  function SpicetifyFolderOwnership() {
    AssertPackagesInstalled "flatpak" "sed" "grep"

    if [[ $? -eq 0 ]]; then
      local installations="$(flatpak --installations)"
      local ref="$(flatpak info com.spotify.Client | grep "Ref: " | sed "s/^.*: //")"
      local files_path="$installations/$ref/active/files/extra/share/spotify"

      sudo chmod a+wr "$files_path"
      sudo chmod a+wr -R "$files_path/Apps"
    fi
  }

  # PARAMETRI
  # t (theme): lista di nomi validi di temi.
  # f (folder): fornisce a spicetify i permessi di lettura e scrittura
  #             sulle cartelle richieste dalla wiki.
  function Spicetify() {
    AssertPackagesInstalled "flatpak" "wget" "curl" "grep"

    if [[ $? -eq 0 ]]; then
      local THEMES=

      while getopts 't:' opt; do
        case ${opt} in
        t)
          THEMES=($OPTARG)
          ;;
        ?)
          return 1
          ;;
        esac
      done

      curl -fsSL 'https://raw.githubusercontent.com/spicetify/cli/main/install.sh' | sh
      flatpak list | grep 'com.spotify.Client'

      if [ $? -eq 0 ]; then
        PrintLog "Trovata installazione di Spotify. Continuo..."

        if [ ${#THEMES[@]} -gt 0 ]; then
          for theme in ${THEMES[*]}; do
            local FOLDER="$(GetDotsDir)/spicetify/Themes/$theme"

            PrintLog "Installo il tema $(PrintExample "$theme") per Spicetify."

            mkdir -p "$FOLDER"
            cd "$FOLDER"
            wget -O "https://raw.githubusercontent.com/spicetify/spicetify-themes/master/$theme/color.ini" color.ini
            wget -O "https://raw.githubusercontent.com/spicetify/spicetify-themes/master/$theme/user.css" user.css
          done
        else
          PrintInfo "Non sono trovati temi da installare."
        fi

        PrintLog "Concessione permessi di lettura e scrittura..."
        PrintInfo "Perché? Vedi https://spicetify.app/docs/advanced-usage/installation#spotify-installed-from-flatpak"
        SpicetifyFolderOwnership

        PrintInfo "Per terminare la configurazione, avviare Spotify ed eseguire il login."
        PrintInfo "Successivamente, eseguire $(PrintExample 'spicetify backup apply')."

      else
        PrintErr "Impossibile procedere per Spicetify."
        PrintErr "Spotify non è installato sul sistema o non è in formato Flatpak."
      fi
    fi
  }

fi
