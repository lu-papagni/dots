#!/usr/bin/env bash

source "utils/definitions.sh"
source "utils/functions.sh"

SCRIPT_DIR="$(echo $(cd "$(dirname $0)" && pwd))"    # Cartella da cui si sta eseguendo lo script

# pacchetti da installare
RequiredPackages=(
    'neovim'    # editor di testo
    'kitty'     # terminale
    'zsh'       # shell
    'bat'       # alternativa per cat (evidenzia la sintassi del linguaggio)
    'lsd'       # alternativa a ls
    'btop'      # monitor risorse
    'fastfetch' # fetch tool
    'flatpak'   # scarica pacchetti da Flathub
    'nodejs'    # runtime di javascript
    'npm'       # node package manager
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
while getopts ":dshl" arg
do
    case $arg in
        d)
            DEBUG=true    # cosa fare con i comandi da runnare: di default li esegue, ma li può anche solo mostrare su stdout per debug
            WarnText "lo script è in modalità test."
            ;;
        s)
            PKG_MAN_INSTALLED=false
            SKIP_HYPR_CHECK=true
            WarnText "disabilitato controllo dei pre-requisiti software."
            ;;
        h)
            PrintUsage
            exit 0
            ;;
        l)  LOG_ENABLED=true
            WarnText "log attivato."
            ;;
        *)
            echo -e "$LI_ERROR È stato inserito un parametro non valido."
            PrintUsage
            exit -1
            ;;
    esac
done
unset arg

# input nome del package manager
read -p "$(echo -e "$LI_INPUT Package manager utilizzato:") " manager

case $manager in
    "dnf")
        install_cmd="install"
        update_cmd="upgrade"
        ;;
    "pacman" | "yay")
        install_cmd="-S --needed"
        update_cmd="-Syu"
        ;;
    *)
        echo -e "$LI_ERROR Package manager '$manager' non supportato."
        exit 1
        ;;
esac

# controlla se il package manager è corretto
if [ "$PKG_MAN_INSTALLED" = true ]; then
    which $manager > /dev/null
    if [ $? -ne 0 ]; then
        echo -e "$LI_ERROR Il package manager '$manager' non esiste sul sistema"
        exit 2
    fi
fi

# conferma per continuare
read -p "$(echo -e "$LI_INPUT Pronto per l'esecuzione. Continuare? (S/N): ")" confirm \
&& [[ $confirm == [sS] || $confirm == [sS][iI] ]] || exit -2

# aggiorna il sistema
echo -e "$LI_INFO Esecuzione aggiornamento completo del sistema..."
Run "$(WithPrivilege $manager) $update_cmd"

# Lettura dei pacchetti da installare

#TipText "Stanno per essere installati solo i pacchetti strettamente necessari."
#TipText "I file devono essere nella stessa directory di questo script."

while read -p "$(echo -e "$LI_INPUT Vuoi indicare un nuovo file da cui leggere i pacchetti da installare? (S/N) ")" confirm && \
[[ $confirm == [sS] || $confirm == [sS][iI] ]]
do
    read -p "$(echo -e "$LI_INPUT Nome file: ")" packageFile
    while read line || [ -n "$line" ]
    do
        echo -e "$LI_INFO Aggiungo: $(UnderlineText "$line")"
        RequiredPackages+=("$line")
    done < "$SCRIPT_DIR/$packageFile"
done

# installa i pacchetti di sistema
echo -e "$LI_INFO Installazione pacchetti..."
Run "$(WithPrivilege $manager) $install_cmd $(
    for pkg in ${RequiredPackages[*]}; do
        printf '%s ' $pkg
    done
)"

# setup flatpak
which "flatpak" > /dev/null
if [ $? -eq 0 ]; then
    echo -e "$LI_INFO Configurazione Flathub remote..."
    flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
    echo -e "$LI_INFO Installazione flatpak..."
    Run "sudo flatpak install $(
        for pkg in ${Flatpak[*]}; do
            printf '%s ' $pkg
        done
    )"
else
    echo -e "$LI_ERROR Non è stato possibile configurare Flatpak sul sistema."
fi

if [ "$manager" = "dnf" ]; then
    # abilita le user repository di Fedora (Copr)
    echo -e "$LI_INFO Abilitazione delle COPR preferite..."
    for repo in ${Copr[*]}; do
        Run "$(WithPrivilege $manager) copr enable $repo"
    done

    # installa i pacchetti delle Copr
    echo -e "$LI_INFO Installazione pacchetti delle COPR..."
    Run "$(WithPrivilege $manager) $install_cmd $(
        for pkg in ${CoprPackages[*]}; do
            printf '%s ' $pkg
        done
    )"
else if [ "$manager" = "pacman" ]; then
        # installazione yay
        read -p "$(echo -e "$LI_INPUT Installare l'AUR helper 'yay' ? (S/N): ")" confirm
        if [[ $confirm == [sS] || $confirm == [sS][iI] ]]; then
            echo -e "$LI_INFO Clonazione repo e compilazione pacchetto..."
            Run "sudo pacman -S --needed git base-devel && git clone https://aur.archlinux.org/yay-bin.git && cd yay-bin && makepkg -si"
            echo -e "$LI_INFO Pulizia file di installazione..."
            Run "rm -rf yay-bin"
        fi
     fi
fi

# imposta la shell predefinita
echo -e "$LI_INFO Cambio la shell predefinita a zsh..."
Run "sudo chsh -s $(which zsh) $(whoami)"

# plugin di zsh (assumendo zsh installata)
# Oh My Zsh
Run "sh -c $(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
# zsh-syntax-highlighting
Run "git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"
# zsh-autosuggestions
Run "git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
# powerlevel10k
Run "git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"

# crea collegamenti simbolici
read -p "$(echo -e "$LI_INPUT Creare collegamenti simbolici da $(UnderlineText "$SCRIPT_DIR") a $(UnderlineText "~/.config")? (S/N): ")" confirm
if [[ $confirm == [sS] || $confirm == [sS][iI] ]]; then
    echo -e "$LI_INFO Symlink delle directory verso $(UnderlineText "~/.config")..."
    Run "find $SCRIPT_DIR -mindepth 1 -maxdepth 1 -type d -not -path \"*/.git*\" -print0 | xargs -I{} -n1 -0 ln -s $SCRIPT_DIR/{} ~/.config"
    echo -e "$LI_INFO Symlink dei file senza directory verso $(UnderlineText "/home/$(whoami)")..."
    Run "find $SCRIPT_DIR -mindepth 1 -maxdepth 1 -type f -name \".*\" -print0 | xargs -I{} -n1 -0 ln -s $SCRIPT_DIR/{} ~/"
fi

# avviso supporto hyprland su vm
which 'Hyprland' > /dev/null
if [[ $? -eq 0 || "$SKIP_HYPR_CHECK" = true ]]; then
    WarnText "Se vuoi usare 'Hyprland' su macchina virtuale, esporta queste variabili d'ambiente in '.zshrc':"
    echo "WLR_NO_HARDWARE_CURSORS=1"
    echo "WLR_RENDERER_ALLOW_SOFTWARE=1"
fi
