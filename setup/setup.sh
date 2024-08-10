#!/usr/bin/env bash

# ███████╗███████╗████████╗██╗   ██╗██████╗
# ██╔════╝██╔════╝╚══██╔══╝██║   ██║██╔══██╗
# ███████╗█████╗     ██║   ██║   ██║██████╔╝
# ╚════██║██╔══╝     ██║   ██║   ██║██╔═══╝
# ███████║███████╗   ██║   ╚██████╔╝██║
# ╚══════╝╚══════╝   ╚═╝    ╚═════╝ ╚═╝

set -ue

#### IMPOSTAZIONI ####

readonly SETUP_TARGET_USER="${1:-$(read -p 'Inserire nome utente: ')}"

case "$(whoami)" in
liveuser | root)     # Impostazioni da usare durante l'installazione di EndeavourOS
  SETUP_OUTPUT_OFF=1 # Disabilito il logging nell'installazione non interattiva

  if [[ -z $SETUP_TARGET_USER ]]; then
    Log --error "Utente non valido."
    exit 1
  fi

  readonly SETUP_HOME="/home/$SETUP_TARGET_USER"

  # Scarico i file
  git clone --recurse-submodules "https://github.com/lu-papagni/dots" "$SETUP_HOME/.dotfiles"
  ;;
esac

readonly SETUP_KONSAVE_PROFILE="endeavour" # Profilo di konsave da caricare

#### ESECUZIONE ####

# Vado nella directory delle librerie così posso importarle
cd "${SETUP_HOME:-$HOME}/.dotfiles/setup/lib"

set +e

# Importo le librerie
source "utils/fmt.sh"
source "linking.sh"
source "packages.sh"
source "shell.sh"
source "spicetify.sh"

# Effettua il link simbolico dei file
Log "Link simbolico file di configurazione..."
LinkDotfiles -d "${SETUP_HOME:-$HOME}/.dotfiles"

# Installa i pacchetti dalle fonti specificate
Log "Installazione pacchetti..."
InstallPackages -s "aur" -s "kde" -s "btrfs" -s "flathub"

# Imposta la shell
Log "Impostazione della shell..."
SetupShell -s "zsh" -p "zinit"

# Spicetify
Log "Configurazione di Spicetify..."
SpicetifyConfig -t "text"

# Imposto il nome delle cartelle in inglese
Log "Imposto nome directory in inglese"
mkdir -p "${SETUP_HOME:-$HOME}/.config"
echo "en_US" >"${SETUP_HOME:-$HOME}/.config/user-dirs.locale"

# Uscita
Log "Setup terminato. Riavviare il terminale per rendere effettive le modifiche."
