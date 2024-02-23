#!/usr/bin/env bash

################################   DICHIARAZIONI   #####################################

# Decorazioni di linea
LI_INFO="\e[1;32m::\e[0m"
LI_INPUT="\e[1;33m::\e[0m"
LI_ERROR="\e[1;31m::\e[0m"

# Colori
HI_DIM="\e[1;30m"    # Grigio
HI_RST="\e[0m"       # Reset

# Directory da cui lo script si sta eseguendo
SCRIPT_DIR="$(dirname "$0")"

# rende il testo grigio
function DIM_TEXT {
    echo "$HI_DIM$1$HI_RST"
}

# crea una scritta di warning
function WARN_TEXT {
    echo -e "\e[1;33mWARNING> $1$HI_RST"
}

# crea una scritta di suggerimento
function TIP_TEXT {
    echo -e "\e[1;32mTIP> $1$HI_RST"
}

# esegue o mostra in versione debug un comando
function RUN {
    if [ "$DEBUG" = true ]; then
        echo -e "$(DIM_TEXT 'DEBUG>') $1"
    else
        $1
    fi
}

function USAGE {
    echo "
    Comandi disponibili:
    -d    ->    Modalità debug: i comandi non vengono eseguiti ma mostrati a schermo
    -s    ->    Non controlla se il package manager specificato è installato.
    -h    ->    Aiuto: mostra questo messaggio
    "
    exit 0
}

# pacchetti da installare
RequiredPackages=(
    'neovim'    # editor di testo
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
    'python-cairo' # dipendenza di blueman
    'pavucontrol'    # audio manager
    'light'     # gestore della retroilluminazione
    'nm-applet' # menu di rete
    'wlogout'   # menu logout
    'mpv'       # visualizzatore video
    'lsd'       # alternativa a ls
    'btop'      # monitor risorse
    'fastfetch' # fetch tool
    'pulseaudio-utils'   # layer compatibilità per pulseaudio
    'which'     # sembra strano ma a volte non è incluso nell'installazione base
    'flatpak'   # scarica pacchetti da Flathub
)

# user repository da attivare
Copr=(
    'erikreider/SwayNotificationCenter'
    'solopasha/hyprland'
    'eddsalkield/swaylock-effects'
)

# pacchetti non inclusi nella repository standard
CoprPackages=(
    'hyprland'                 # window manager
    'hyprpaper'                # wallpaper utility
    'SwayNotificationCenter'   # daemon/centro notifiche
    'swaylock-effects'         # schermata di blocco
)

# Pacchetti da scaricare da FlatHub
Flatpak=(
    'spotify'
)

################################   ESECUZIONE   #####################################

echo "
  _  __ _        _          _                _            _     
 | |/ /(_)      | |        | |              | |          | |    
 | ' /  _   ___ | | __ ___ | |_  __ _  _ __ | |_     ___ | |__  
 |  <  | | / __|| |/ // __|| __|/ _\` || '__|| __|   / __|| '_ \ 
 | . \ | || (__ |   < \__ \| |_| (_| || |   | |_  _ \__ \| | | |
 |_|\_\|_| \___||_|\_\|___/ \__|\__,_||_|    \__|(_)|___/|_| |_|
                                                                
"

# se sono stati passati argomenti allo script
while getopts ":dsh" _SEP
do
    case $_SEP in
        d)
            DEBUG=true    # cosa fare con i comandi da runnare: di default li esegue, ma li può anche solo mostrare su stdout per debug
            WARN_TEXT "lo script è in modalità test. I comandi importanti non verranno eseguiti, ma stampati."
            ;;
        s)
            PKG_MAN_INSTALLED=true
            WARN_TEXT "è stato disabilitato il controllo sull'effettiva presenza del package manager."
            ;;
        h)
            USAGE
            ;;
        *)
            echo -e "$LI_ERROR '$1' non è un parametro valido."
            exit -1
            ;;
    esac
done

# input nome del package manager
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
if [ "$PKG_MAN_INSTALLED" = true ]; then
    if [ $? -ne 0 ]; then
        echo -e "$LI_ERROR Il package manager '$manager' non esiste sul sistema"
        exit -1
    fi
fi

# conferma per continuare
read -p "$(echo -e "$LI_INPUT Pronto per l'esecuzione. Continuare? (Y/N): ")" confirm && [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]] || exit 1

# aggiorna il sistema
echo -e "$LI_INFO Esecuzione aggiornamento completo del sistema..."
RUN "sudo $manager $update_cmd"

# Lettura dei pacchetti da installare
TIP_TEXT "Stanno per essere installati solo i pacchetti strettamente necessari."
TIP_TEXT "I file devono essere nella stessa directory di questo script."

while read -p "$(echo -e "$LI_INPUT Vuoi indicare un nuovo file da cui leggere i pacchetti? (Y/N) ")" usePackageFile && \
[[ $usePackageFile == [yY] || $usePackageFile == [yY][eE][sS] ]]
do
    read -p "$(echo -e "$LI_INPUT Nome file: ")" packageFile
    while read -r line
    do
        echo -e "$LI_INFO Aggiungo: $(DIM_TEXT "$line")"
        RequiredPackages+=("$line")
    done < "$SCRIPT_DIR/$packageFile"
done

# installa i pacchetti di sistema
echo -e "$LI_INFO Installazione pacchetti..."
RUN "sudo $manager $install_cmd $(
    for pkg in ${RequiredPackages[*]}; do
        printf '%s ' $pkg
    done
)"

echo -e "$LI_INFO Configurazione Flathub remote..."
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

echo -e "$LI_INFO Installazione flatpak..."
RUN "sudo flatpak install $(
    for pkg in ${Flatpak[*]}; do
        printf '%s ' $pkg
    done
)"

if [ $manager == "dnf" ]; then
    # abilita le user repository di Fedora (Copr)
    echo -e "$LI_INFO Abilitazione delle COPR preferite..."
    for repo in ${Copr[*]}; do
        RUN "sudo $manager copr enable $repo"
    done

    # installa i pacchetti delle Copr
    echo -e "$LI_INFO Installazione pacchetti delle COPR..."
    RUN "sudo $manager $install_cmd $(
        for pkg in ${CoprPackages[*]}; do
            printf '%s ' $pkg
        done
    )"
fi

# imposta la shell predefinita
echo -e "$LI_INFO Cambio della shell predefinita a zsh..."
RUN "sudo chsh -s "$(which zsh)" "$(whoami)""

# crea collegamenti simbolici
read -p "$(echo -e "$LI_INPUT Creare collegamenti simbolici da $(DIM_TEXT "$SCRIPT_DIR") a $(DIM_TEXT "~/.config")? (Y/N): ")" confirm
if [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]]; then
    RUN "find $SCRIPT_DIR -mindepth 1 -maxdepth 1 -type d,f -not -path "*/.git*" -print0 | xargs -I{} -n1 -0 ln -s {} "~/.config""
fi

# avviso supporto hyprland su vm
which 'Hyprland' > /dev/null
if [ $? -eq 0 ]; then
    echo -e "$LI_INPUT Attenzione: se vuoi usare $(DIM_TEXT 'Hyprland') su macchina virtuale, abilita queste variabili d'ambiente in $(DIM_TEXT '.zshrc'):"
    echo -e "$LI_INPUT $(DIM_TEXT 'WLR_NO_HARDWARE_CURSORS') impostata ad $(DIM_TEXT '1')"
    echo -e "$LI_INPUT $(DIM_TEXT 'WLR_RENDERER_ALLOW_SOFTWARE') impostata ad $(DIM_TEXT '1')"
fi
