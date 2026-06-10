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
  direnv
  zsh-autosuggestions
  zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# --- User Configuration & Tools ---

# Bind Ctrl + f to accept autosuggest
bindkey '^F' autosuggest-accept

# Initialize Zoxide
eval "$(zoxide init zsh --cmd cd)"

# Initialize direnv
eval "$(direnv hook zsh)"

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

# Helpers for tmux
# Exit current session.
alias tks="tmux kill-session"
# Split terminal: 50% wide left pane, two stacked right panes
t3l() {
    if [ -n "$TMUX" ]; then
        tmux split-window -h -p 50 \; split-window -v \; select-pane -t 0
    else
        tmux new-session \; split-window -h -p 50 \; split-window -v \; select-pane -t 0
    fi
}

# Split terminal: 2 stacked left panes, 50% wide right pane
t3r() {
    if [ -n "$TMUX" ]; then
        tmux split-window -h -p 50 -d \; split-window -v \; select-pane -t 1
    else
        tmux new-session \; split-window -h -p 50 -d \; split-window -v \; select-pane -t 1
    fi
}

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# --- Load Local Private Configuration ---
if [ -f ~/.zshrc.local ]; then
  source ~/.zshrc.local
fi
