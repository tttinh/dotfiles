#!/bin/sh
set -e

TARGET_DIR="$HOME"
DOTFILES_DIR="$HOME/.dotfiles"

PACKAGES="zsh nvim powerlevel10k tmux"

fmt_info()    { printf '\033[1;34m%s\033[0m\n' "$1"; }
fmt_success() { printf '\033[1;32m%s\033[0m\n' "$1"; }
fmt_error()   { printf '\033[1;31m%s\033[0m\n' "$1"; }
fmt_warn()    { printf '\033[1;33m%s\033[0m\n' "$1"; }

confirm() {
  printf '\033[1;33m%s [y/N] \033[0m' "$1"
  read -r answer
  case "$answer" in
    [yY]*) return 0 ;;
    *)     return 1 ;;
  esac
}

remove_stow() {
  if [ ! -d "$DOTFILES_DIR" ]; then
    fmt_error "Dotfiles directory not found at $DOTFILES_DIR. Nothing to unstow."
    return
  fi

  cd "$DOTFILES_DIR"
  fmt_info "Removing symlinks for all packages..."
  for package in $PACKAGES; do
    if [ -d "$DOTFILES_DIR/$package" ]; then
      fmt_info "-> Unstowing package: $package"
      stow --verbose=1 --dotfiles --target="$TARGET_DIR" -D "$package" 2>/dev/null || true
    fi
  done
}

restore_backups() {
  fmt_info "Checking for backup files to restore..."
  found=0
  for package in $PACKAGES; do
    [ -d "$DOTFILES_DIR/$package" ] || continue
    find "$DOTFILES_DIR/$package" -type f | while read -r src; do
      rel="${src#"$DOTFILES_DIR/$package/"}"
      backup="$TARGET_DIR/${rel}.pre-dotfiles"
      if [ -f "$backup" ]; then
        fmt_info "Restoring $backup -> $TARGET_DIR/$rel"
        mv "$backup" "$TARGET_DIR/$rel"
        found=1
      fi
    done
  done
  if [ "$found" = 0 ]; then
    fmt_info "No backup files found."
  fi
}

remove_tmux_plugins() {
  if [ -d "$HOME/.tmux/plugins" ]; then
    if confirm "Remove TPM and tmux plugins (~/.tmux/plugins)?"; then
      rm -rf "$HOME/.tmux/plugins"
      fmt_success "Removed tmux plugins."
    fi
  fi
}

remove_omz() {
  if [ -d "$HOME/.oh-my-zsh" ]; then
    if confirm "Remove Oh My Zsh (~/.oh-my-zsh)?"; then
      rm -rf "$HOME/.oh-my-zsh"
      fmt_success "Removed Oh My Zsh."
    fi
  fi
}

remove_neovim_data() {
  if [ -d "$HOME/.local/share/nvim" ] || [ -d "$HOME/.local/state/nvim" ] || [ -d "$HOME/.cache/nvim" ]; then
    if confirm "Remove Neovim plugin data (~/.local/share/nvim, ~/.local/state/nvim, ~/.cache/nvim)?"; then
      rm -rf "$HOME/.local/share/nvim" "$HOME/.local/state/nvim" "$HOME/.cache/nvim"
      fmt_success "Removed Neovim data."
    fi
  fi
}

remove_dotfiles_repo() {
  if [ -d "$DOTFILES_DIR" ]; then
    if confirm "Remove the dotfiles repository ($DOTFILES_DIR)?"; then
      rm -rf "$DOTFILES_DIR"
      fmt_success "Removed dotfiles repository."
    fi
  fi
}

main() {
  echo ""
  fmt_info "--- Dotfiles Uninstall Script ---"
  echo ""

  remove_stow
  restore_backups

  echo ""
  fmt_warn "The following steps are optional and will ask for confirmation."
  echo ""

  remove_tmux_plugins
  remove_omz
  remove_neovim_data
  remove_dotfiles_repo

  echo ""
  fmt_success "Uninstall complete! Restart your terminal for changes to take effect."
}

main "$@"
