# Created by Zap installer
[ -f "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh" ] && source "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh"
plug "zsh-users/zsh-autosuggestions"
plug "zap-zsh/supercharge"
plug "zap-zsh/zap-prompt"
plug "zsh-users/zsh-syntax-highlighting"
plug "rkh/zsh-jj"

# Load and initialise completion system
autoload -Uz compinit
compinit

export EDITOR="nvim"
export VISUAL="nvim"



export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Custom

bindkey -v
alias ls='eza'


alias python=python3
source ~/ansible/hacking/env-setup
# BEGIN ANSIBLE MANAGED BLOCK for direnv
# direnv setup
# END ANSIBLE MANAGED BLOCK for direnv
. "$HOME/.cargo/env"

eval "$(direnv hook zsh)"
# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/buckholz/.c3/standards/apps/conda/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/buckholz/.c3/standards/apps/conda/etc/profile.d/conda.sh" ]; then
        . "/Users/buckholz/.c3/standards/apps/conda/etc/profile.d/conda.sh"
    else
        export PATH="/Users/buckholz/.c3/standards/apps/conda/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<
conda activate

export PATH=$PATH:$(go env GOPATH)/bin
export C3_AUTH_TOKEN='eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzUxMiJ9.eyJhcHAiOiJzdGdhd3NoaWktYnVja2hvbHpubnMxLW5uc3BzbyIsImZpcnN0bmFtZSI6IlRyZW50IiwiaXNzIjoiYzMuYWkiLCJncm91cHMiOlsiQzMuQXBwQWRtaW4iLCJDMy5FbnZBZG1pbiJdLCJsYXN0bmFtZSI6IkJ1Y2tob2x6Iiwic2lkIjozMSwiYXVkIjoiYzMuYWkiLCJpZHAiOiIiLCJjM2dyb3VwcyI6WyJDMy5BcHBBZG1pbiIsIkMzLkVudkFkbWluIl0sImlkcHVzZXJpZCI6IjAwdTF1NzlldGI1OVBaZGZ4MWQ4IiwiaWRwZ3JvdXBzIjoie1wiT2lkY0lkcENvbmZpZzo6c3RnYXdzaGlpLmMzLmFpXCI6W1wic3RnYXdzaGlpLmMzLmFpL0MzLlN0dWRpb1VzZXJcIixcInN0Z2F3c2hpaS5jMy5haS9DMy5KYXJ2aXNTZXJ2aWNlQWRtaW5cIl19Iiwic3NpZHgiOiIiLCJuYW1lIjoiVHJlbnQuQnVja2hvbHpAYzMuYWkiLCJzc2VxIjozMSwiaWQiOiJUcmVudC5CdWNraG9sekBjMy5haSIsImV4cCI6MTc1ODMyMTk4NzAwMCwiZW1haWwiOiJUcmVudC5CdWNraG9sekBjMy5haSJ9.IPO1h4F7aU09roE3nnlSDw16kiBY4H0oLw1IXuhJj3h5Hbng8aKkVKPa26BpCF3ZzRtvUuhfE5vQa1tjiBKgpPqe5tCbaleJZviU68H6uCdw3niqZFLqOxsrBLksMXFeUHhElISfC4WZF3bJLuk4G0yRf1ICCDY6jF58LYQMYI1SMbb1bi56KzXGs5FvdJlOqr44X-l8lM3C6cgadlM21K_Hd0SljJrF51LR7r-wTHCPwuztPcsjjpyaPxejEWdsoL8L9KSvUq0Hd42b8KHuylxGfNnL0jkpKH-NJXnt0FS1--1zYFzGJGH6PtvPfMx-EEhv8Gg4MInrhkEktLZ9Kw'
alias run_console="/Users/buckholz/side_projects/c3cli-rust/target/release/run_console"
alias ingest_canonical="/Users/buckholz/side_projects/c3cli-rust/target/release/ingest_canonical"
alias run_test="/Users/buckholz/side_projects/c3cli-rust/target/release/run_test"
ingest_all_canonicals() { /Users/buckholz/side_projects/c3cli-rust/target/release/run_console "$@" '[c3.SourceFile.syngAll(fsc.inboxUrl(), {"process": True}) for fsc in
 c3.FileSourceCollection.fetch().objs]' }



cdf() {
    cd "$(fd -t d . ~ | sk)"
}

clear_sync_files() {
    find . -name ".fingerprints.txt" -type f -delete
    find . -name ".vscode" -type d -exec rm -rf {} +
    find . -name ".vs-cache" -type d -exec rm -rf {} +
}

source <(COMPLETE=zsh jj)

nvm use 22

lint_files() {
    pre-commit run --files $(jj diff --name-only | tr '\n' ' ')
}

