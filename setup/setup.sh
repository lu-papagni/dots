#!/usr/bin/env bash

function LinkDotfiles ()
{
  local EXCLUDED_DIRS=(
    "zsh"
    "setup"
  )
  local DOTS_DIR="$HOME/.dotfiles"

  [ -d "$HOME/.config" ] || mkdir "$HOME/.config"

  echo "Collegamento simbolico delle directory..."

  # Soft link dotfiles
  find $DOTS_DIR -maxdepth 1 -type d -not -path "$DOTS_DIR/.*" $(
    for dir in ${EXCLUDED_DIRS[*]}
    do
      echo -n "-and -not -path "$DOTS_DIR/$dir" "
    done
  ) \
  | xargs -I{} ln -s {} "$HOME/.config"

  # Soft link zsh
  ln -s "$HOME/.dotfiles/zsh/.zshrc" "$HOME"

  echo "... fine collegamento simbolico."
}

function SetupShell ()
{
  local SHELL="zsh"

  # Plugin e temi provengono da github
  local PLUGINS=(
    "zsh-users/zsh-autosuggestions"
    "zsh-users/zsh-syntax-highlighting"
  )

  local THEMES=(
    "romkatv/powerlevel10k"
  )

  # Controllo se la shell è installata
  which "$SHELL" > /dev/null

  if [[ $? -eq 0 ]] then

    echo "Installo Oh-My-Zsh..."
    echo "ATTENZIONE: per procedere nel setup, uscire da zsh con CTRL+D."

    # Oh-My-Zsh
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

    echo "Installo i plugin della shell..."

    # Plugin
    for plugin in ${PLUGINS[*]}
    do
      local NAME="${plugin#*/}"   # Scarta tutto fino allo slash
      git clone --depth=1 "https://github.com/$plugin.git" "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/$NAME"
    done

    echo "Installo i temi della shell..."

    # Temi
    for theme in ${THEMES[*]}
    do
      local NAME="${theme#*/}"   # Scarta tutto fino allo slash
      git clone --depth=1 "https://github.com/$theme.git" "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/$NAME"
    done

    if [[ -f "$HOME/.zshrc.pre-oh-my-zsh" ]] then
      rm "$HOME/.zshrc" && mv "$HOME/.zshrc.pre-oh-my-zsh" "$HOME/.zshrc"
    fi

    echo "Cambio shell predefinita..."

    # Cambia shell predefinita
    chsh -s "$(which $SHELL)" "$(whoami)"

    echo "... configurazione shell terminata."
    
  else
    # Stampa errore
    echo "Shell '$SHELL' non installata."
  fi  
}

InstallPackages ()
{
  local SOURCES=("aur" "flathub")

  # Parsing file
  for source in ${SOURCES[*]}; do

    local PGK_MANAGER=""
    local INSTALL_CMD=""
    local PACKAGES=()
    local SUDO=""

    echo "Lettura lista dei pacchetti (fonte '$source')..."

    for line in $(cat "sources/$source.txt"); do
      if [[ ! $line == !* ]] then
        PACKAGES+=("$line")
      else
        PKG_MANAGER="${line#*\!}"   # Scarta tutto fino al punto esclamativo
      fi
    done

    case "$PKG_MANAGER" in
      "yay") INSTALL_CMD="-S"
        ;;
      "flatpak") INSTALL_CMD="install"; SUDO="sudo"
        ;;
      *) echo "'$PKG_MANAGER' non supportato."
        ;;
    esac

    echo "Installazione pacchetti (fonte '$source')..."
    # Composizione del comando per installare i pacchetti
    $SUDO $PKG_MANAGER $INSTALL_CMD $(
      for pkg in ${PACKAGES[*]}; do
        printf "$pkg "
      done
    )

  done  # Fine parsing

  echo "... fine installazione pacchetti."
}

# Inizio esecuzione
LinkDotfiles
InstallPackages
SetupShell

# Uscita
read -p "Setup terminato. Premi INVIO per uscire..."
exit
