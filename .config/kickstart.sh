#!/usr/bin/env bash

LI_INFO="\e[1;32m::\e[0m"
LI_INPUT="\e[1;33m::\e[0m"
LI_ERROR="\e[1;31m::\e[0m"

packages=(
    'neovim'    # editor di testo
    'firefox'   # browser
    'kitty'     # terminale
    'zsh'       # shell
    'bat'       # alternativa per cat (evidenzia la sintassi del linguaggio)
    'cava'      # visualizzatore musica per terminale
    'gnome-calculator'    # calcolatrice di gnome
    'onedrive'  # daemon per sincronizzare i file con OneDrive
    'waybar'    # barra degli strumenti
    'wofi'      # menu delle applicazioni
    'swayidle'  # daemon per controllare lo standby
    'blueman'   # bluetooth manager
    'pavucontrol'    # audio manager
    'light'     # gestore della retroilluminazione
    'eog'       # visualizzatore immagini
    'wlogout'   # menu logout
    'vlc'       # visualizzatore video
)

copr=(
    'erikreider/SwayNotificationCenter'
    'solopasha/hyprland'
    'eddsalkield/swaylock-effects'
)

copr_packages=(
    'hyprland'                          # window manager
    'SwayNotificationCenter'            # daemon/centro notifiche
    'swaylock-effects'                  # schermata di blocco
)

if [ ! -z $1 ]; then
    case $1 in
        "--dry-run")
            DEBUG="echo"    # cosa fare con i comandi da runnare: di default li esegue, ma li può anche solo mostrare su stdout per debug
            echo -e "$LI_INPUT Attenzione: lo script è in modalità test. I comandi importanti non verranno eseguiti, ma stampati."
            ;;
        *)
            echo -e "$LI_ERROR '$1' non è un parametro valido."
            exit -1
            ;;
    esac
fi

read -p "$(echo -e "$LI_INPUT Package manager utilizzato:") " manager

case $manager in
    "dnf")
        install_cmd="install"
        update_cmd="upgrade"
        ;;
    "pacman")
        install_cmd="-S"
        update_cmd="-Syu"
        ;;
    *)
        echo -e "$LI_ERROR Package manager '$manager' non supportato."
        exit -1
        ;;
esac

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
$DEBUG sudo $manager $update_cmd

# installa i pacchetti
echo -e "$LI_INFO Installazione pacchetti..."
$DEBUG sudo $manager $install_cmd $(
    for pkg in ${packages[*]}; do
        printf '%s ' $pkg
    done
)

if [ $manager == "dnf" ]; then
    # abilita le user repository di Fedora (copr)
    echo -e "$LI_INFO Abilitazione delle COPR preferite..."
    for repo in ${copr[*]}; do
        $DEBUG sudo $manager copr enable $repo
    done

    # installa i pacchetti delle copr
    echo -e "$LI_INFO Installazione pacchetti delle COPR..."
    $DEBUG sudo $manager $install_cmd $(
        for pkg in ${copr_packages[*]}; do
            printf '%s ' $pkg
        done
    )
fi

echo -e "$LI_INFO Cambio della shell predefinita a zsh..."
$DEBUG sudo chsh -s "/usr/bin/zsh" "$(whoami)"
