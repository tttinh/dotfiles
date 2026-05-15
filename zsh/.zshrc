# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load
ZSH_THEME="powerlevel10k/powerlevel10k"

# --- Oh My Zsh Plugins ---
plugins=(
  git
  sudo
  docker
  docker-compose
  terraform
  nvm                      # Added OMZ's built-in NVM plugin for faster/lazy loading
  zsh-autosuggestions
  zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# --- User Configuration & Tools ---

# Bind Ctrl + f to accept autosuggest
bindkey '^F' autosuggest-accept

# Initialize Zoxide
eval "$(zoxide init zsh --cmd cd)"

# Initialize FZF
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# --- Convenient Aliases ---
alias nz="nvim ~/.zshrc.local"
alias n="nvim"
alias lg="lazygit"
alias lk="lazydocker"
alias ndot="nvim ~/.dotfiles/"
alias cdot="cd ~/.dotfiles/"
alias devu="devpod up . --ide none"
alias devr="devpod up . --recreate --ide none"
alias devd="devpod delete ."

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# --- Load Local Private Configuration ---
if [ -f ~/.zshrc.local ]; then
  source ~/.zshrc.local
fi
