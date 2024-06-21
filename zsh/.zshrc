# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

# fzf setup
source <(fzf --zsh)

# Neovim setup
export PATH="$PATH:/opt/nvim-linux64/bin"

# NVM setup
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# GPG setup
export GPG_TTY=$(tty)

# Starship.rs setup
eval "$(starship init zsh)"
