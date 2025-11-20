#!/bin/bash

# --- Configuration ---
DOTFILES_REPO="git@github.com:tttinh/dotfiles.git"
DOTFILES_DIR="$HOME/.dotfiles"
TARGET_DIR="$HOME"
PACKAGES=("git" "zsh" "nvim") # Packages to install via Stow
# --- End Configuration ---

## 1. Prerequisites Check (Stow and Git)
for cmd in git stow; do
  if ! command -v "$cmd" &>/dev/null; then
    echo "?? Error: $cmd is required but not installed. Please install it."
    exit 1
  fi
done

## 2. Clone the Dotfiles Repository
echo "Cloning dotfiles..."
if [ -d "$DOTFILES_DIR" ]; then
  echo "?? Dotfiles directory exists. Pulling latest changes."
  cd "$DOTFILES_DIR" && git pull
else
  git clone --depth=1 "$DOTFILES_REPO" "$DOTFILES_DIR"
  cd "$DOTFILES_DIR" || exit 1
fi

## 3. Install oh-my-zsh (Special Case: Framework)
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "Installing oh-my-zsh framework..."
  # The official OMZ installer uses curl.
  sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
  echo "oh-my-zsh already installed."
fi

## 4. Symlink with Stow
echo "---"
echo "? Creating symlinks for all configurations..."

for package in "${PACKAGES[@]}"; do
  echo "-> Stowing package: $package"
  # --dotfiles handles .zshrc, .gitconfig, and the hidden .config directory structure
  stow --verbose=1 --dotfiles --target="$TARGET_DIR" "$package"

  if [ $? -ne 0 ]; then
    echo "   ? Stow failed for $package. Check for conflicts."
  fi
done

## 5. LazyVim Installation (Special Case: Installer)
# After stowing the nvim config, we need to run the LazyVim setup script.
# This assumes Neovim is already installed on the new machine.
echo "---"
echo "Running LazyVim setup..."
nvim --headless -c 'Lazy sync' -c 'qa'

echo "---"
echo "?? Setup complete! Run 'source ~/.zshrc' or restart your terminal."
