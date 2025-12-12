# Created by Zap installer
[ -f "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh" ] && source "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh"
plug "zsh-users/zsh-autosuggestions"
plug "zap-zsh/supercharge"
plug "zap-zsh/zap-prompt"
plug "zsh-users/zsh-syntax-highlighting"
plug "rkh/zsh-jj"

source <(COMPLETE=zsh jj)
source <(fzf --zsh)

# Load and initialise completion system
autoload -Uz compinit
compinit

export EDITOR="nvim"
export VISUAL="nvim"



export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion


# Custom

bindkey -v
alias ls='eza'


alias python=python3
. "$HOME/.cargo/env"


cdf() {
    cd "$(fd -t d . ~ | sk)"
}

nvm use 22

lint_files() {
    pre-commit run --files $(jj diff --name-only | tr '\n' ' ')
}

