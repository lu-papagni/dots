#!/usr/bin/env bash

source "./utils/logic.sh"

SCRIPT_DIR="$(cd `dirname $0` && pwd)"

# Impostazioni shell
SHELL="zsh"
SHELL_PLUGIN_MGR="zinit"

# Fonti di installazione
SOURCES=(
  "aur"
  "kde"
  "btrfs"
  "flathub"
)

# Directory dei dotfiles
DOTS_DIR="$(cd $SCRIPT_DIR && cd .. && pwd)"

# Directory da non considerare per il link simbolico
EXCLUDE_FROM_LINK=(
  "zsh"
  "setup"
)

### Esecuzione ###

LinkDotfiles
# link simbolico manuale per directory escluse da $EXCLUDE_FROM_LINK
ln -s "$DOTS_DIR/zsh/.zshrc" "$HOME"

InstallPackages
SetupShell

# Configurazione Spicetify
Spicetify

# Setup kwallet
PrintLog "Configurazione di kwallet..."
mkdir -p ~/.config/environment.d
echo "GIT_ASKPASS=/usr/bin/ksshaskpass" > ~/.config/environment.d/git_askpass.conf

# Uscita
PrintLog "Script terminato con successo. Riavviare il terminale per rendere effettive le modifiche."
