#!/bin/sh

set -e -u

plog() { printf '[INFO]\t%s\n' "$*"; }
pwarn() { printf '[WARN]\t%s\n' "$*"; }
perror() { printf '[FAIL]\t%s\n' "$*" >&2; }

update() {
	config="$1"
	pacman="$(basename $config)"

	case "$pacman" in
		pacman|yay)
			sudo pacman -Syu --noconfirm ;;
		apt*)
			sudo apt-get update -y && apt-get upgrade -y ;;
		dnf)
			sudo dnf upgrade -y ;;
		zypper)
			sudo zypper dup -y ;;
		*)
			return 1 ;;
	esac
}

install() {
	config="$1"
	pacman="$(basename $config)"

	case "$pacman" in
		*) install_cmd='install' ;;&
		pacman|yay) install_cmd='-S --needed' ;;
		apt*) no_weak_deps='--no-install-recommends' ;;
		dnf) no_weak_deps='--setopt=install_weak_deps=False' ;;
		zypper) no_weak_deps='--no-recommends' ;;
	esac

	xargs sudo "$pacman" "$install_cmd" "${no_weak_deps:-}" < "$config"
}

import() {
	src="$1"
	dest="$2"
	shift 2

	# Allow only directories as target, so managing the link name isn't needed
	[ -d "$dest" ] || return 1

	for item in "$@"; do
		if [ -e "$src/$item" ]; then
			# Detect and remove existing configuration
			existing="$dest/$item"
			if [ -e "$existing" ] && [ ! -L "$existing" ]; then
				pwarn "Found conflicting config: $existing"
				# Use -I for interactive prompt unless FORCE_OVERWRITE is set (for testing)
				if [ "${FORCE_OVERWRITE:-}" = "1" ]; then
					rm -rf "$existing"
				else
					rm -rfI "$existing"
				fi
			fi

			ln -s "$src/$item" "$dest" 2>/dev/null || true
		else
			perror "Target $item does not exist in $src"
		fi
	done
}

# Main script execution (skip if sourced for testing)
if [ "${INIT_SH_SOURCED:-}" != "1" ]; then
	if ! command -v git >/dev/null; then
		perror "git is required to run $0"
		exit 1
	fi

	readonly REPO='https://github.com/lu-papagni/dots.git'
	readonly DOTS_DIR="${1:-$HOME/.dotfiles}"

	plog "Checking out dotfiles"
	if ! [ -d "$DOTS_DIR" ]; then
		git clone --recurse-submodules "$REPO" "$DOTS_DIR"
	fi

	# Bring nvim config to latest version
	git -C "$DOTS_DIR/nvim" checkout experimental >/dev/null 2>&1

	plog "Importing settings"
	import "$DOTS_DIR" ~/.config nvim tmux btop clangd zsh
	import "$DOTS_DIR" ~ .p10k.zsh .zshenv .gitconfig
	mkdir -p ~/.local/bin && import "$DOTS_DIR" ~/.local/bin BIN/opencode-wrapper

	if [ -n "${WSLENV:-}" ]; then
		plog "Performing WSL specific tasks"
		if [ -r "${DOTS_DIR}/wsl/wsl.conf" ]; then
			[ -f '/etc/wsl.conf' ] && sudo rm /etc/wsl.conf
			sudo ln -sf "$DOTS_DIR/wsl/wsl.conf" /etc 
		else
			pwarn "No WSL config found in $DOTS_DIR"
		fi

		if [ -r "${DOTS_DIR}/wsl/fstab" ]; then
			sudo cat "${DOTS_DIR}/wsl/fstab" >> /etc/fstab
		else
			pwarn "No custom fstab found in $DOTS_DIR"
		fi
	fi

	plog "Installing missing packages"
	if [ -d "$DOTS_DIR/PACKAGES" ]; then
		for config in "$DOTS_DIR"/PACKAGES/*; do
			# Run only if that package manager is installed
			command -v "$(basename "$config")" >/dev/null || continue
			update "$config" || perror "$config" "Could not update system: you must be root!"
			install "$config" || perror "$config" "Could not install: you must be root!"
		done
	else
		pwarn "Skipping package installation: no packages to install"
	fi
fi

