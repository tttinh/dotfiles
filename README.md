# Dotfiles

Personal dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/).

## What's Included

| Package        | Description                                      |
| -------------- | ------------------------------------------------ |
| `zsh`          | `.zshrc` and `.zprofile`                         |
| `nvim`         | [LazyVim](https://www.lazyvim.org/) config       |
| `powerlevel10k`| [Powerlevel10k](https://github.com/romkatv/powerlevel10k) theme config |

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
- `curl` or `wget`

## Manual Install

```bash
git clone --depth=1 https://github.com/tttinh/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install.sh
```
