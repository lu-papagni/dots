#!/bin/bash
DO="exec"    # cosa fare con i comandi da runnare: di default li esegue, ma li può anche solo mostrare su stdout per debug
LI_INFO="\e[1;32m::\e[0m"
LI_INPUT="\e[1;33m::\e[0m"
LI_ERROR="\e[1;31m::\e[0m"
packages=('neovim' 'firefox' 'kitty' 'zsh' 'bat' 'cava' 'gnome-calculator' 'onedrive' 'waybar' 'wofi' 'swayidle' 'swaylock')

if [ ! -z $1 ]; then
    case $1 in
        "--dry-run")
            DO="echo"
            echo -e "$LI_INPUT Attenzione: lo script è in modalità test. I comandi importanti verranno solo mostrati in output."
            ;;
        *)
            echo -e "$LI_ERROR '$1' non è un parametro valido."
            exit -1
            ;;
    esac
fi

read -p "$(echo -e "$LI_INPUT Package manager utilizzato:") " manager

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

# conferma per continuare
read -p "$(echo -e "$LI_INPUT Pronto per l'esecuzione. Continuare? (Y/N): ")" confirm && [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]] || exit 1

# aggiorna il sistema
echo -e "$LI_INFO Esecuzione aggiornamento completo del sistema..."
$DO "sudo $manager $update_cmd"

# installa i pacchetti
echo -e "$LI_INFO Installazione pacchetti richiesti..."
$DO "sudo $manager $install_cmd $(
    for pkg in ${packages[*]}; do
        printf '%s ' $pkg
    done
)"
