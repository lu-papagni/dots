#!/bin/sh

set -e -u

install() {
	config="$1"
	pacman="$(basename $config)"
	xargs "$pacman" < "$config"
}

import() {
	src="$1"
	dest="$2"
	shift 2

	for item in "$@"; do
		ln -s "$src/$item" "$dest"
	done
}

if ! command -v git >/dev/null; then
	echo "[ERROR] git is required to run $0"
	exit 1
fi

readonly REPO='https://github.com/lu-papagni/dots.git'
readonly DOTS_DIR="$1"

git clone --recurse-submodules "$REPO" "$DOTS_DIR"
# Bring nvim config to latest version
git -C "$DOTS_DIR/nvim" checkout experimental

# Configure programs
import "$DOTS_DIR" ~/.config nvim tmux btop clangd zsh
import "$DOTS_DIR" ~ .p10k.zsh .zshenv .gitconfig

# Install missing packages
if [ -d "$DOTS_DIR/PACKAGES" ]; then
	for config in "$DOTS_DIR"/PACKAGES/*; do
		install "$config"
	done
else
	echo "[WARNING] skipping package installation: no packages to install"
fi

