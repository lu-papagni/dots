#!/usr/bin/env bash

source "./src/utils/fmt.sh"
source "./src/linking.sh"
source "./src/packages.sh"
source "./src/shell.sh"
source "./src/spicetify.sh"

# ███████╗███████╗████████╗██╗   ██╗██████╗
# ██╔════╝██╔════╝╚══██╔══╝██║   ██║██╔══██╗
# ███████╗█████╗     ██║   ██║   ██║██████╔╝
# ╚════██║██╔══╝     ██║   ██║   ██║██╔═══╝
# ███████║███████╗   ██║   ╚██████╔╝██║
# ╚══════╝╚══════╝   ╚═╝    ╚═════╝ ╚═╝

PrintLog "Link simbolico file di configurazione..."
StowDotfiles -n

# Installa i pacchetti dalle fonti specificate
PrintLog "Installazione pacchetti..."
InstallPackages -s "aur kde btrfs flathub"

# Imposta la shell
PrintLog "Impostazione della shell..."
SetupShell -s "zsh" -p "zinit"

# Spicetify
PrintLog "Configurazione di Spicetify..."
Spicetify -t "text"

# Se KDE è installato
if [[ ! -z $KDE_SESSION_VERSION ]]; then
  # Setup kwallet
  PrintLog "Configurazione di kwallet..."
  KWalletSetup
fi

# Uscita
PrintLog "Setup terminato. Riavviare il terminale per rendere effettive le modifiche."
