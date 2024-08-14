#!/usr/bin/env bash

# ███████╗███████╗████████╗██╗   ██╗██████╗
# ██╔════╝██╔════╝╚══██╔══╝██║   ██║██╔══██╗
# ███████╗█████╗     ██║   ██║   ██║██████╔╝
# ╚════██║██╔══╝     ██║   ██║   ██║██╔═══╝
# ███████║███████╗   ██║   ╚██████╔╝██║
# ╚══════╝╚══════╝   ╚═╝    ╚═════╝ ╚═╝

set -ue

#### IMPOSTAZIONI ####

readonly SETUP_TARGET_USER="${1:-$(whoami)}"

case "$(whoami)" in
liveuser | root)     # Impostazioni da usare durante l'installazione di EndeavourOS
  SETUP_OUTPUT_OFF=1 # Disabilito il logging nell'installazione non interattiva

  if [[ -z $SETUP_TARGET_USER ]]; then
    Log --error "Utente non valido."
    exit 1
  fi

  HOME="/home/$SETUP_TARGET_USER"

  # Scarico i file
  git clone --recurse-submodules "https://github.com/lu-papagni/dots" "$HOME/.dotfiles"
  ;;
esac

readonly SETUP_KONSAVE_PROFILE="endeavour" # Profilo di konsave da caricare

#### ESECUZIONE ####

# Vado nella directory del setup
cd "$HOME/.dotfiles/setup"

set +e

# Importo le librerie
source "lib/utils/fmt.sh"
source "lib/linking.sh"
source "lib/packages.sh"
source "lib/shell.sh"
source "lib/spicetify.sh"

# Effettua il link simbolico dei file
Log "Link simbolico file di configurazione..."
LinkDotfiles -d "$HOME/.dotfiles"

# Installa i pacchetti dalle fonti specificate
Log "Installazione pacchetti..."
InstallPackages \
  -s "archlinux/aur" \
  -s "archlinux/kde" \
  -s "archlinux/btrfs" \
  -s "flathub"

# Imposta la shell
Log "Impostazione della shell..."
SetupShell -s "zsh" -p "zinit"

# Spicetify
Log "Configurazione di Spicetify..."
SpicetifyConfig -t "text"

# Imposto il nome delle cartelle in inglese
Log "Imposto nome directory in inglese"
if [[ ! -r "$HOME/.config/user-dirs.locale" ]]; then
  mkdir -p "$HOME/.config"
  echo "en_US" >"$HOME/.config/user-dirs.locale"
fi

# Uscita
Log "Setup terminato. Riavviare il terminale per rendere effettive le modifiche."
