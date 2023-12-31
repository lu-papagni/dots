#!/bin/env bash

LI_INFO="\e[1;32m::\e[0m"
LI_INPUT="\e[1;33m::\e[0m"
LI_ERROR="\e[1;31m::\e[0m"
packages=('neovim' 'firefox')
read -p "$(echo -e "$LI_INPUT Package manager utilizzato:") " manager

update_cmd="null"
if [ $manager == "dnf" ]; then
    install_cmd="install"
    update_cmd="upgrade"
elif [ $manager == "pacman" ]; then
    install_cmd="-S"
    update_cmd="-Syu"
else
    echo -e "$LI_ERROR Package manager '$manager' non supportato."
    exit -1
fi

# controlla se il package manager è corretto
which $manager > /dev/null
if [ $? -ne 0 ]; then
    echo -e "$LI_ERROR Il package manager '$manager' non esiste sul sistema"
    exit -1
fi

# devono essere eseguiti con 'exec', 'echo' è solo per test
# aggiorna il sistema
echo -e "$LI_INFO Esecuzione aggiornamento completo del sistema"
echo "sudo $manager $update_cmd"
# installa i pacchetti
echo -e "$LI_INFO Installazione pacchetti richiesti"
echo "sudo $manager $install_cmd $(
    for pkg in ${packages[*]}; do
        printf '%s ' $pkg
    done
)"