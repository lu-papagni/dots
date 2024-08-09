#!/usr/bin/env bash

source "$(dirname ${BASH_SOURCE[0]:-$0})/utils/fmt.sh"

# ███████╗██╗  ██╗███████╗██╗     ██╗
# ██╔════╝██║  ██║██╔════╝██║     ██║
# ███████╗███████║█████╗  ██║     ██║
# ╚════██║██╔══██║██╔══╝  ██║     ██║
# ███████║██║  ██║███████╗███████╗███████╗
# ╚══════╝╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝

[[ -v __DEFINE_SHELLSETUP ]] && return
readonly __DEFINE_SHELLSETUP

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

    Log "Installo Oh-My-Zsh..."

    # Oh-My-Zsh
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc

    Log "Installo i plugin della shell..."

    # Plugin
    for plugin in ${PLUGINS[*]}; do
      local NAME="${plugin#*/}" # Scarta tutto fino allo slash
      git clone --depth=1 "https://github.com/$plugin.git" "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/$NAME"
    done

    Log "Installo i temi della shell..."

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
# u (user): per quale utente cambiare la shell
function SetupShell() {
  AssertExecutable "whoami" "chsh"

  if [[ $? -eq 0 ]]; then
    local shell
    local plugin_mgr
    local shell_user="${SETUP_TARGET_USER:-$(whoami)}"

    while getopts 's:p:u:h' opt; do
      case "$opt" in
      s)
        shell="$OPTARG"
        ;;
      p)
        plugin_mgr="$OPTARG"
        ;;
      u)
        shell_user="$OPTARG"
        ;;
      h)
        echo "Configura la nuova shell e la imposta come predefinita.\n"
        column "$(pwd)/help/setup-shell.txt" -tL -s '|'
        return 0
        ;;
      ?)
        return 1
        ;;
      esac
    done

    # Se non sono state date queste informazioni
    if [[ -z "$shell" || -z "$plugin_mgr" ]]; then
      Log --error "Non sono stati forniti tutti i parametri obbligatori."
      return 1
    fi

    # Controllo se la shell è installata
    AssertExecutable "$shell"

    if [[ $? -eq 0 ]]; then
      Log "Configuro $(Highlight "$plugin_mgr") come plugin manager per $(Highlight "$shell")"

      case "$plugin_mgr" in
      zinit)
        Log "$(Highlight "zinit") verrà configurato al primo avvio della shell."
        ;;
      omz)
        OhMyZsh
        ;;
      *)
        Log --error "Plugin manager non supportato."
        return 1
        ;;
      esac

      Log "Modifica della shell predefinita..."

      # Cambia shell predefinita per l'utente $shell_user
      chsh -s "$(command -v $shell)" "$shell_user"

      Log "... configurazione shell terminata."

    else
      Log --error "Shell '$shell' non installata."
      return 1
    fi

  else
    return 1
  fi
}
