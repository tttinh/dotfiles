# Dotfiles

Personal dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/).

## What's Included

| Package        | Description                                      |
| -------------- | ------------------------------------------------ |
| `zsh`          | `.zshrc` and `.zprofile`                         |
| `nvim`         | [LazyVim](https://www.lazyvim.org/) config       |
| `powerlevel10k`| [Powerlevel10k](https://github.com/romkatv/powerlevel10k) theme config |
| `tmux`         | [tmux](https://github.com/tmux/tmux) config with [TPM](https://github.com/tmux-plugins/tpm) |

The install script also sets up:

- [Oh My Zsh](https://ohmyz.sh/) framework
- [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)
- [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting)

## Quick Install

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/tttinh/dotfiles/main/install.sh)"
```

or with wget:

```bash
sh -c "$(wget -O- https://raw.githubusercontent.com/tttinh/dotfiles/main/install.sh)"
```

## Prerequisites

The following must be installed before running the script:

- `git`
- `stow`
- `zsh`
- `nvim`
- `tmux`
- `curl` or `wget`

## Manual Install

```bash
git clone --depth=1 https://github.com/tttinh/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install.sh
```

## Fresh Machine Setup

After running the install script on a new machine, a few extra steps are needed:

1. **Zsh** — restart your terminal or run `source ~/.zshrc`
2. **Neovim** — open `nvim` and wait for LazyVim to auto-install plugins
3. **Tmux** — open `tmux`, then press `prefix + I` to install TPM plugins

## Adding a New Package

Each package is a directory in the repo that mirrors the home directory structure. [GNU Stow](https://www.gnu.org/software/stow/) creates symlinks from `~` into the dotfiles repo.

1. **Create the package directory** matching where the config lives relative to `~`:

   ```bash
   # For a config file at ~/.somerc
   mkdir -p ~/.dotfiles/some
   cp ~/.somerc ~/.dotfiles/some/.somerc

   # For a config file at ~/.config/tool/config.toml
   mkdir -p ~/.dotfiles/tool/.config/tool
   cp ~/.config/tool/config.toml ~/.dotfiles/tool/.config/tool/config.toml
   ```

2. **Register the package** in `install.sh` by adding its name to the `PACKAGES` variable:

   ```bash
   PACKAGES="zsh nvim powerlevel10k tmux some"
   ```

3. **If the tool has a plugin manager** (like TPM for tmux), add a setup function in `install.sh` to clone it using the existing `clone_if_missing` helper, and call it from `main()`.

4. **Stow it** to create the symlink (remove the original file first if it exists):

   ```bash
   cd ~/.dotfiles
   stow --dotfiles --target="$HOME" some
   ```

5. **Update this README** — add the package to the table and prerequisites list.
