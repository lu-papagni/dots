#!/usr/bin/env bash

source "$(dirname ${BASH_SOURCE[0]:-$0})/utils/fmt.sh"
source "$(dirname ${BASH_SOURCE[0]:-$0})/utils/assert.sh"

# ██████╗  █████╗  ██████╗██╗  ██╗ █████╗  ██████╗ ███████╗███████╗
# ██╔══██╗██╔══██╗██╔════╝██║ ██╔╝██╔══██╗██╔════╝ ██╔════╝██╔════╝
# ██████╔╝███████║██║     █████╔╝ ███████║██║  ███╗█████╗  ███████╗
# ██╔═══╝ ██╔══██║██║     ██╔═██╗ ██╔══██║██║   ██║██╔══╝  ╚════██║
# ██║     ██║  ██║╚██████╗██║  ██╗██║  ██║╚██████╔╝███████╗███████║
# ╚═╝     ╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝ ╚══════╝╚══════╝

[[ -v __DEFINE_PACKAGEINST ]] && return
readonly __DEFINE_PACKAGEINST

# Compila ed installa i pacchetti della AUR senza `yay` durante un'installazione automatica
function BuildAurAsRoot() {
  local directory="/tmp"

  while getopts 'u:h' opt; do
    case "$opt" in
    u)
      if [[ -z "$OPTARG" ]]; then
        directory="/home/$OPTARG/.cache/yay"
        mkdir -p "$directory"
      fi
      ;;
    h)
      echo "Permette di installare i pacchetti della AUR quando si è root senza triggerare l'errore di makepkg."
      echo "È particolarmente utile nelle installazioni non interattive dove viene usato chroot.\n"
      column "help/build-aur.txt" -tL -s '|'
      return 0
      ;;
    esac
  done

  AssertExecutable "git" "makepkg" "pacman"

  if [[ $? -eq 0 ]]; then
    echo "nobody ALL = (root) NOPASSWD: $(command -v pacman)" >/etc/sudoers.d/nobody

    for pkg in "$@"; do
      git clone "https://aur.archlinux.org/$pkg.git" "$directory/$pkg"
      chown -R nobody "$directory/$pkg"
      (
        cd "$directory/$pkg" &&
          sudo -u nobody makepkg -s --needed --asdeps --noconfirm &&
          pacman -U *.tar.zst --noconfirm
      )
    done

    rm /etc/sudoers.d/nobody
  fi
}

# PARAMETRI
# -s (sources): lista delle fonti di installazione
function InstallPackages() {
  AssertExecutable "sed" "head" "tail"

  if [[ $? -eq 0 ]]; then
    local src_dir="${SETUP_HOME:-$HOME}/.dotfiles/sources"
    local sources=()

    while getopts 's:h' opt; do
      case "$opt" in
      s)
        sources+=($OPTARG)
        ;;
      h)
        echo "Installa i pacchetti presenti nelle liste specificate.\n"
        column "help/install-packages.txt" -tL -s '|'
        return 0
        ;;
      ?)
        Log --error "Sintassi errata."
        return 1
        ;;
      esac
    done

    # Controllo se sono stati forniti i parametri
    if [[ -z $sources ]]; then
      Log --error "Installazione pacchetti: non sono state forniti i parametri."
      return 1
    fi

    # Controllo se esiste la directory
    [[ -d "$src_dir" ]] || return 1

    # Parsing del file
    for source in ${sources[@]}; do
      local pgk_manager=""
      local install_cmd=""
      local packages=()
      local privilege=""
      local skip_confirm_cmd=""

      Log "Lettura lista dei pacchetti: $(Highlight "$source")"

      # Controllo se il file è leggibile
      if [[ ! -r "$src_dir/$source.txt" ]]; then
        Log --error "Il file non è leggibile."
        continue
      fi

      # Leggo il package manager da usare alla prima riga del file
      pkg_manager="$(head -n 1 "$src_dir/$source.txt" | sed s/\!//)"

      # Salvo ogni pacchetto da installare, uno per riga
      for line in $(tail -n +2 "$src_dir/$source.txt"); do
        packages+=("$line")
      done

      # Imposto i comandi da eseguire in base al package manager
      case "$pkg_manager" in
      yay | pacman)
        skip_confirm_cmd="--noconfirm"
        ;;
      pacman)
        privilege="sudo"
        install_cmd="-S --needed"
        ;;
      yay)
        install_cmd="-S --needed --clean"
        ;;
      flatpak)
        install_cmd="install"
        privilege="sudo"
        skip_confirm_cmd="--assumeyes"
        ;;
      dnf | apt | 'apt-get')
        privilege="sudo"
        install_cmd="install"
        skip_confirm_cmd="-y"
        ;;
      *)
        Log --error "$(Highlight "$pkg_manager") non è supportato."
        return 1
        ;;
      esac

      # Controllo che il package manager sia installato
      AssertExecutable "$pkg_manager"

      if [[ $? -eq 0 ]]; then
        Log "Installazione pacchetti (fonte $(Highlight "$source"))..."

        if [[ "$pkg_manager" = "yay" && -v SETUP_NO_INTERACTIVE ]]; then
          BuildAurAsRoot -u "${SETUP_TARGET_USER}" "${packages[@]}"
        else
          # Composizione del comando per installare i pacchetti
          ${SHELL:-$(command -v bash)} -c "$privilege $pkg_manager $install_cmd $skip_confirm_cmd ${packages[@]}"
        fi
      fi

    done # Fine parsing

    # Se KDE deve essere configurato
    if [[ -n "$SETUP_KONSAVE_PROFILE" && -r "konsave/profiles/$SETUP_KONSAVE_PROFILE" ]]; then
      Log "Caricamento profilo $(Highlight "$SETUP_KONSAVE_PROFILE")..."
      AssertExecutable "konsave" && konsave -a "konsave/profiles/$SETUP_KONSAVE_PROFILE"
    fi

    Log "... fine installazione pacchetti."
  fi
}
