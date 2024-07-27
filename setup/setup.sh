#!/usr/bin/env bash

SETUP_SCRIPT_DIR="$(cd $(dirname $0) && pwd)"
SETUP_DOTS_DIR="$(cd "$SETUP_SCRIPT_DIR" && cd .. && pwd)"

source "lib/utils/fmt.sh"
source "lib/linking.sh"
source "lib/packages.sh"
source "lib/shell.sh"
source "lib/spicetify.sh"
source "lib/kwallet.sh"

# ███████╗███████╗████████╗██╗   ██╗██████╗
# ██╔════╝██╔════╝╚══██╔══╝██║   ██║██╔══██╗
# ███████╗█████╗     ██║   ██║   ██║██████╔╝
# ╚════██║██╔══╝     ██║   ██║   ██║██╔═══╝
# ███████║███████╗   ██║   ╚██████╔╝██║
# ╚══════╝╚══════╝   ╚═╝    ╚═════╝ ╚═╝

PrintLog "Link simbolico file di configurazione..."
LinkDotfiles

# Installa i pacchetti dalle fonti specificate
PrintLog "Installazione pacchetti..."
InstallPackages -s "aur kde btrfs flathub"

# Imposta la shell
PrintLog "Impostazione della shell..."
SetupShell -s "zsh" -p "zinit"

# Spicetify
PrintLog "Configurazione di Spicetify..."
SpicetifyConfig -t "text"

# Se KDE è installato
if [[ ! -z $KDE_SESSION_VERSION ]]; then
  # Setup kwallet
  PrintLog "Configurazione di kwallet..."
  KWalletSetup
fi

# Uscita
PrintLog "Setup terminato. Riavviare il terminale per rendere effettive le modifiche."
