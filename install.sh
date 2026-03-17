#!/bin/sh
set -e

DOTFILES_REPO="https://github.com/tttinh/dotfiles.git"
TARGET_DIR="$HOME"
DOTFILES_DIR="$HOME/.dotfiles"

PACKAGES="zsh nvim powerlevel10k"

fmt_info()    { printf '\033[1;34m%s\033[0m\n' "$1"; }
fmt_success() { printf '\033[1;32m%s\033[0m\n' "$1"; }
fmt_error()   { printf '\033[1;31m%s\033[0m\n' "$1"; }

command_exists() { command -v "$1" >/dev/null 2>&1; }

fetch() {
  if command_exists curl; then
    curl -fsSL "$1"
  elif command_exists wget; then
    wget -qO- "$1"
  else
    fmt_error "Error: curl or wget is required but neither is installed."
    exit 1
  fi
}

setup_prerequisites() {
  fmt_info "Checking for prerequisites (git, stow, zsh, nvim)..."
  for cmd in git stow zsh nvim; do
    if ! command_exists "$cmd"; then
      fmt_error "Error: $cmd is required but not installed. Please install it."
      exit 1
    fi
  done
  fmt_success "Prerequisites installed."
}

setup_dotfiles_repo() {
  if [ -d "$DOTFILES_DIR" ]; then
    fmt_info "Dotfiles directory already exists. Pulling latest changes."
    cd "$DOTFILES_DIR" && git pull
  else
    fmt_info "Cloning dotfiles repository..."
    git clone --depth=1 "$DOTFILES_REPO" "$DOTFILES_DIR"
  fi
  cd "$DOTFILES_DIR" || {
    fmt_error "Failed to enter $DOTFILES_DIR"
    exit 1
  }
}

setup_omz() {
  ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

  if [ ! -d "$HOME/.oh-my-zsh" ]; then
    fmt_info "Installing oh-my-zsh framework..."
    sh -c "$(fetch https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc
  else
    fmt_info "oh-my-zsh already installed."
  fi
}

clone_if_missing() {
  local target="$1" repo="$2" name="$3" opts="${4:-}"
  if [ -d "$target" ]; then
    fmt_info "$name already installed. Skipping."
  else
    fmt_info "Cloning $name..."
    git clone $opts "$repo" "$target"
  fi
}

setup_zsh_plugins() {
  ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

  fmt_info "Installing Zsh custom plugins..."
  clone_if_missing "$ZSH_CUSTOM/plugins/zsh-autosuggestions" \
    "https://github.com/zsh-users/zsh-autosuggestions" "zsh-autosuggestions"
  clone_if_missing "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" \
    "https://github.com/zsh-users/zsh-syntax-highlighting.git" "zsh-syntax-highlighting"
  clone_if_missing "$ZSH_CUSTOM/themes/powerlevel10k" \
    "https://github.com/romkatv/powerlevel10k.git" "powerlevel10k" "--depth=1"
}

backup_conflicts() {
  package="$1"
  find "$DOTFILES_DIR/$package" -type f | while read -r src; do
    rel="${src#"$DOTFILES_DIR/$package/"}"
    target="$TARGET_DIR/$rel"
    if [ -f "$target" ] && [ ! -L "$target" ]; then
      fmt_info "Backing up $target -> ${target}.pre-dotfiles"
      mv "$target" "${target}.pre-dotfiles"
    fi
  done
}

setup_stow() {
  fmt_info "Creating symlinks for all configurations..."
  for package in $PACKAGES; do
    backup_conflicts "$package"
    fmt_info "-> Stowing package: $package"
    if ! stow --verbose=1 --dotfiles --target="$TARGET_DIR" "$package"; then
      fmt_error "Stow failed for $package. Check for conflicting files in $HOME."
    fi
  done
}

setup_neovim() {
  if command_exists nvim && [ -d "$HOME/.config/nvim" ]; then
    fmt_info "Neovim config linked. Open 'nvim' to complete plugin installation."
  else
    fmt_info "LazyVim setup skipped. Ensure Neovim is installed to finalize the setup."
  fi
}

main() {
  echo ""
  fmt_info "--- Dotfiles Setup Script ---"
  echo ""

  setup_prerequisites
  setup_dotfiles_repo
  setup_omz
  setup_zsh_plugins
  setup_stow
  setup_neovim

  echo ""
  fmt_success "Setup complete! Run 'source ~/.zshrc' or restart your terminal."
}

# Wrapping in main() ensures the entire script is downloaded
# before execution begins (protects against partial downloads).
main "$@"
