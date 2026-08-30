# Zap plugin manager
[ -f "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh" ] && source "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh"

# zsh-vi-mode config — must be set before the plug call
ZVM_ESCAPE_KEYTIMEOUT=0.01  # 10ms, matches fish_escape_delay_ms

# fzf keybindings get clobbered by zsh-vi-mode; re-apply them after init
function zvm_after_init() {
  command -v fzf &>/dev/null && source <(fzf --zsh)
}

# Plugins
plug "zsh-users/zsh-autosuggestions"
plug "zap-zsh/supercharge"
plug "zsh-users/zsh-syntax-highlighting"
plug "rkh/zsh-jj"
plug "jeffreytse/zsh-vi-mode"

# Completion
autoload -Uz compinit
compinit

# Starship prompt
eval "$(starship init zsh)"

# --- History (fish parity) ---
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000
setopt SHARE_HISTORY          # share history across sessions like fish
setopt HIST_IGNORE_ALL_DUPS   # deduplicate, keeping newest
setopt HIST_IGNORE_SPACE      # don't record commands prefixed with space
setopt HIST_REDUCE_BLANKS

# --- Directory navigation (fish parity) ---
setopt AUTO_PUSHD             # every cd pushes to stack (fish-like dir history)
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_SILENT

# --- Environment ---
export EDITOR="nvim"
export VISUAL="nvim"
export VCPKG_ROOT=/Users/trent/vcpkg

# --- PATH ---
export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"
export PATH="/Users/tbuckholz/.local/bin:$PATH"
export PATH="$HOME/Development/chalk/cli:$PATH"
[[ -n "$VIRTUAL_ENV" ]] && export PATH="$VIRTUAL_ENV/bin:$PATH"
if command -v go &>/dev/null; then
  export PATH="$PATH:$(go env GOPATH)/bin"
fi

# --- Cargo ---
. "$HOME/.cargo/env"

# --- NVM ---
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"
nvm use 22 &>/dev/null

# --- jj completion ---
if command -v jj &>/dev/null; then
  source <(COMPLETE=zsh jj)
fi

# --- Aliases ---
alias ls='eza'
alias python=python3

# --- Functions ---
cdf() {
  local dir
  dir=$(fd -t d . ~ | fzf)
  [[ -n "$dir" ]] && cd "$dir"
}

lint_files() {
  local files
  files=$(jj diff --name-only | tr '\n' ' ')
  [[ -z "${files// }" ]] && { echo "No changed files in jj diff."; return 0; }
  pre-commit run --files $files
}

source_dev_env_chalk() {
  local env_file=/Users/trent/Development/chalk/chalk-private/development.env
  [[ -f "$env_file" ]] || { echo "Missing $env_file" >&2; return 1; }
  set -a; source "$env_file"; set +a
}

chalklocal() {
  local original_dir="$PWD"
  cd ~/Development/chalk/cli || return 1
  GOOS=darwin GOARCH=arm64 go build -o chalk || { cd "$original_dir"; return 1; }
  cd "$original_dir"
  ~/Development/chalk/cli/chalk "$@"
}

# --- System limits (fish parity) ---
ulimit -n 65536
