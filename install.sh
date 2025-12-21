#!/bin/bash

# --- Configuration ---
# !!! UPDATE THESE VALUES !!!
DOTFILES_REPO="git@github.com:tttinh/dotfiles.git"
TARGET_DIR="$HOME"
DOTFILES_DIR="$HOME/.dotfiles"

# List the package directories (MUST match the folder names in your repo: git, zsh, nvim)
PACKAGES=(
  "zsh"
  "nvim"
  "powerlevel10k"
  # Add any other packages here (e.g., "tmux", "alacritty")
)
# --- End Configuration ---

echo "--- Dotfiles Setup Script ---"

## 1. Check for Prerequisites
echo "Checking for prerequisites (git, stow)..."
for cmd in git stow; do
  if ! command -v "$cmd" &>/dev/null; then
    echo "?? Error: $cmd is required but not installed. Please install it."
    exit 1
  fi
done
echo "? Prerequisites installed."

## 2. Clone the Dotfiles Repository
echo "---"
if [ -d "$DOTFILES_DIR" ]; then
  echo "?? Dotfiles directory already exists. Pulling latest changes."
  cd "$DOTFILES_DIR" && git pull
else
  echo "? Cloning dotfiles repository..."
  git clone --depth=1 "$DOTFILES_REPO" "$DOTFILES_DIR"
fi
cd "$DOTFILES_DIR" || {
  echo "? Failed to enter $DOTFILES_DIR"
  exit 1
} # Ensure we are in the repo

## 3. Install oh-my-zsh Framework
# ZSH_CUSTOM defines where OMZ stores custom themes/plugins.
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
echo "---"

if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "Installing oh-my-zsh framework..."
  # The official OMZ installer using the --unattended flag to avoid prompting
  sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
  echo "oh-my-zsh already installed."
fi

## 4. Install Zsh Plugins
echo "---"
echo "? Installing Zsh custom plugins..."

# A. Install zsh-autosuggestions
if [ -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
  echo "zsh-autosuggestions already installed. Skipping clone."
else
  echo "Cloning zsh-autosuggestions..."
  git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
fi

# B. Install zsh-syntax-highlighting
if [ -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
  echo "zsh-syntax-highlighting already installed. Skipping clone."
else
  echo "Cloning zsh-syntax-highlighting..."
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
fi

# C. Install powerlevel10k
if [ -d "$ZSH_CUSTOM/themes/powerlevel10k" ]; then
  echo "powerlevel10k already installed. Skipping clone."
else
  echo "Cloning powerlevel10k..."
  git clone --depth=1 https://github.com/romkatv/powerlevel11k.git "$ZSH_CUSTOM/themes/powerlevel10k"
fi

## 5. Symlink Configurations with GNU Stow
echo "---"
echo "? Creating symlinks for all configurations..."

for package in "${PACKAGES[@]}"; do
  echo "-> Stowing package: $package"
  # --dotfiles handles .zshrc, .gitconfig, and the hidden .config directory structure
  stow --verbose=1 --dotfiles --target="$TARGET_DIR" "$package"

  if [ $? -ne 0 ]; then
    echo "   ? Stow failed for $package. Check for conflicting files in $HOME."
  fi
done

## 6. LazyVim/Neovim Setup
# This step requires Neovim to be installed on the new machine first!
if command -v nvim &>/dev/null && [ -d "$HOME/.config/nvim" ]; then
  echo "---"
  echo "Running LazyVim setup..."
  # Run Lazy sync to download plugins and finish installation
  nvim --headless -c 'Lazy sync' -c 'qa'
  echo "LazyVim setup initiated. Run 'nvim' to confirm."
else
  echo "---"
  echo "?? LazyVim setup skipped. Ensure Neovim is installed to finalize the setup."
fi

echo "---"
echo "?? Setup complete! Run 'source ~/.zshrc' or restart your terminal."
