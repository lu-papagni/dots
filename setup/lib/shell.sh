#!/usr/bin/env bash

source "$(dirname ${BASH_SOURCE[0]:-$0})/utils/fmt.sh"

# ███████╗██╗  ██╗███████╗██╗     ██╗
# ██╔════╝██║  ██║██╔════╝██║     ██║
# ███████╗███████║█████╗  ██║     ██║
# ╚════██║██╔══██║██╔══╝  ██║     ██║
# ███████║██║  ██║███████╗███████╗███████╗
# ╚══════╝╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝

if [ ! -v __DEFINE_SHELLSETUP ]; then
  __DEFINE_SHELLSETUP=true

  function OhMyZsh() {
    AssertExecutable "git"

    if [[ $? -eq 0 ]]; then
      while getopts 'h' opt; do
        case "$opt" in
        h)
          echo 'Effettua il setup del plugin manager `oh-my-zsh`.'
          echo 'Non ammette parametri.\n'
          return 0
          ;;
        esac
      done

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
      for plugin in ${PLUGINS[*]}; do
        local NAME="${plugin#*/}" # Scarta tutto fino allo slash
        git clone --depth=1 "https://github.com/$plugin.git" "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/$NAME"
      done

      PrintLog "Installo i temi della shell..."

      # Temi
      for theme in ${THEMES[*]}; do
        local NAME="${theme#*/}" # Scarta tutto fino allo slash
        git clone --depth=1 "https://github.com/$theme.git" "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/$NAME"
      done

      if [[ -f "$HOME/.zshrc.pre-oh-my-zsh" ]]; then
        rm "$HOME/.zshrc" && mv "$HOME/.zshrc.pre-oh-my-zsh" "$HOME/.zshrc"
      fi

    else
      return 1
    fi

  }

  # PARAMETRI
  # s (shell): quale shell installare
  # p (plugin manager): quale plugin manager usare
  function SetupShell() {
    AssertExecutable "whoami" "chsh"

    if [[ $? -eq 0 ]]; then
      local SHELL=
      local PLUGIN_MGR=

      while getopts 's:p:h' opt; do
        case "$opt" in
        s)
          SHELL="${OPTARG}"
          ;;
        p)
          PLUGIN_MGR="${OPTARG}"
          ;;
        h)
          echo "Configura la nuova shell e la imposta come predefinita.\n"
          column "$(dirname ${BASH_SOURCE[0]:-$0})/help/setup-shell.txt" -tL -s '|'
          return 0
          ;;
        ?)
          return 1
          ;;
        esac
      done

      # Se non sono state date queste informazioni
      if [[ -z "$SHELL" || -z "$PLUGIN_MGR" ]]; then
        PrintErr "Non sono stati forniti parametri"
        return 1
      fi

      # Controllo se la shell è installata
      AssertExecutable "$SHELL"

      if [[ $? -eq 0 ]]; then
        PrintLog "È stato indicato $(PrintExample "$PLUGIN_MGR") come plugin manager per la shell $(PrintExample "$SHELL")"

        case "$PLUGIN_MGR" in
        zinit)
          PrintLog "$(PrintExample "zinit") verrà configurato al primo avvio di zsh."
          ;;
        omz)
          OhMyZsh
          ;;
        *)
          PrintErr "Plugin manager non supportato."
          return 1
          ;;
        esac

        PrintLog "Modifica della shell predefinita..."

        # Cambia shell predefinita
        chsh -s "$(which $SHELL)" "$(whoami)"

        PrintLog "... configurazione shell terminata."

      else
        PrintErr "Shell '$SHELL' non installata."
        return 1
      fi

    else
      return 1
    fi
  }
fi
