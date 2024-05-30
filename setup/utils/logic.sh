# Logica principale dello script

source "fmt.sh"

function Spicetify ()
{
  PrintLog "Installazione di Spicetify..."

  curl -fsSL https://raw.githubusercontent.com/spicetify/cli/main/install.sh | sh
  flatpak list | grep com.spotify.Client 

  if [ $? -eq 0 ]; then
    local SPOTIFY_PATH="$(flatpak --installations)/app/com.spotify.Client/x86_64/stable/active/files/extra/share/spotify"
    local THEMES=(
      "text"
    )

    PrintLog "Trovata installazione di Spotify. Continuo..."

    for theme in ${THEMES[*]}
    do
      local FOLDER="$DOTS_DIR/spicetify/Themes/$theme"

      PrintLog "Installo il tema '$theme' per Spicetify."

      mkdir -p "$FOLDER"
      cd "$FOLDER"
      wget -O "https://raw.githubusercontent.com/spicetify/spicetify-themes/master/$theme/color.ini" color.ini
      wget -O "https://raw.githubusercontent.com/spicetify/spicetify-themes/master/$theme/user.css" user.css
    done

    PrintLog "Concedo permesso di scrittura e lettura al percorso di installazione..."
    sudo chmod a+wr "$SPOTIFY_PATH"
    sudo chmod a+wr "$SPOTIFY_PATH/Apps"

    PrintInfo "Per terminare la configurazione, avviare Spotify ed eseguire il login."
    PrintInfo "Successivamente, eseguire 'spicetify backup apply'."

  else
    PrintErr "Impossibile procedere per Spicetify."
    PrintErr "Spotify non è installato sul sistema o non è in formato Flatpak."
  fi
}

function LinkDotfiles ()
{
  [ -d "$HOME/.config" ] || mkdir "$HOME/.config"

  PrintLog "Collegamento simbolico delle directory..."

  # Soft link dotfiles
  find $DOTS_DIR -maxdepth 1 -type d -not -path "$DOTS_DIR/.*" $(
    for dir in ${EXCLUDE_FROM_LINK[*]}
    do
      echo -n "-and -not -path "$DOTS_DIR/$dir" "
    done
  ) \
  | xargs -I{} ln -s {} "$HOME/.config"

  PrintLog "... fine collegamento simbolico."
}

function SetupShell ()
{
  # Controllo se la shell è installata
  which "$SHELL" > /dev/null

  if [[ $? -eq 0 ]] then
    PrintLog "È stato specificato '$SHELL_PLUGIN_MGR' come plugin manager per '$SHELL'"

    case "$SHELL_PLUGIN_MGR" in
      zinit)
        PrintLog "zinit verrà configurato al primo avvio di zsh."
        ;;
      omz)
        # Plugin e temi provengono da github
        local PLUGINS=(
          "zsh-users/zsh-autosuggestions"
          "zsh-users/zsh-syntax-highlighting"
        )

        local THEMES=(
          "romkatv/powerlevel10k"
        )

        PrintLog "Installo Oh-My-Zsh..."

        # Oh-My-Zsh
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc

        PrintLog "Installo i plugin della shell..."

        # Plugin
        for plugin in ${PLUGINS[*]}
        do
          local NAME="${plugin#*/}"   # Scarta tutto fino allo slash
          git clone --depth=1 "https://github.com/$plugin.git" "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/$NAME"
        done

        PrintLog "Installo i temi della shell..."

        # Temi
        for theme in ${THEMES[*]}
        do
          local NAME="${theme#*/}"   # Scarta tutto fino allo slash
          git clone --depth=1 "https://github.com/$theme.git" "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/$NAME"
        done

        if [[ -f "$HOME/.zshrc.pre-oh-my-zsh" ]] then
          rm "$HOME/.zshrc" && mv "$HOME/.zshrc.pre-oh-my-zsh" "$HOME/.zshrc"
        fi
      ;;
      *)
        PrintErr "Plugin manager non supportato."
      ;;
    esac

    PrintLog "Cambio shell predefinita..."

    # Cambia shell predefinita
    chsh -s "$(which $SHELL)" "$(whoami)"

    PrintLog "... configurazione shell terminata."
    
  else
    PrintErr "Shell '$SHELL' non installata."
  fi  
}

InstallPackages ()
{
  # Parsing file
  for source in ${SOURCES[*]}; do

    local PGK_MANAGER=""
    local INSTALL_CMD=""
    local PACKAGES=()
    local SUDO=""
    local SKIP_CONFIRM_CMD=""

    PrintLog "Lettura lista dei pacchetti (fonte '$source')..."

    for line in $(cat "sources/$source.txt"); do
      if [[ ! $line == !* ]] then
        PACKAGES+=("$line")
      else
        PKG_MANAGER="${line#*\!}"   # Scarta tutto fino al punto esclamativo
      fi
    done

    case "$PKG_MANAGER" in
      "yay") INSTALL_CMD="-S"; SKIP_CONFIRM_CMD="--noconfirm"
        ;;
      "flatpak") INSTALL_CMD="install"; SUDO="sudo"; SKIP_CONFIRM_CMD="--assumeyes"
        ;;
      *) PrintErr "'$PKG_MANAGER' non supportato."
        ;;
    esac

    PrintLog "Installazione pacchetti (fonte '$source')..."

    # Composizione del comando per installare i pacchetti
    $SUDO $PKG_MANAGER $INSTALL_CMD $SKIP_CONFIRM_CMD $(
      for pkg in ${PACKAGES[*]}; do
        echo -n "$pkg "
      done
    )

  done  # Fine parsing

  PrintLog "... fine installazione pacchetti."
}
