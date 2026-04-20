# Disable the default fish greeting for parity with zsh startup.
set -g fish_greeting

if status is-interactive
    fish_vi_key_bindings
end

set -gx EDITOR nvim
set -gx VISUAL nvim
set -gx NVM_DIR $HOME/.nvm
set -gx VCPKG_ROOT /Users/trent/vcpkg

if test -f $HOME/.cargo/env
    if command -q bass
        bass source $HOME/.cargo/env
    else
        set -gx PATH $HOME/.cargo/bin $PATH
    end
end

# Mirror the zsh PATH ordering as closely as fish allows.
set -gx PATH /Users/tbuckholz/.local/bin /opt/homebrew/opt/openjdk/bin $PATH

if command -q go
    set -l gopath (go env GOPATH 2>/dev/null)
    if test -n "$gopath"
        set -gx PATH $PATH $gopath/bin
    end
end

set -gx PATH $PATH $HOME/.local/bin

if test -n "$VIRTUAL_ENV"
    set -gx PATH $VIRTUAL_ENV/bin $PATH
end

alias ls='eza'
alias python='python3'

function cdf
    set -l dir (fd -t d . ~ | fzf)
    if test -n "$dir"
        cd "$dir"
    end
end

function lint_files
    set -l files (jj diff --name-only)
    if test (count $files) -eq 0
        echo "No changed files in jj diff."
        return 0
    end

    pre-commit run --files $files
end

function source_dev_env_chalk
    set -l env_file /Users/trent/Development/chalk/chalk-private/development.env

    if not test -f $env_file
        echo "Missing $env_file" >&2
        return 1
    end

    if not command -q bass
        echo "bass is required to source $env_file from fish" >&2
        return 1
    end

    bass source $env_file
end

function chalklocal
    set -l original_dir (pwd)

    cd ~/Development/chalk/cli; or return 1
    env GOOS=darwin GOARCH=arm64 go build -o chalk; or begin
        cd $original_dir
        return 1
    end

    cd $original_dir
    ~/Development/chalk/cli/chalk $argv
end

function fish_vcs_prompt
    if command -q jj
        set -l jj_bookmarks (jj --ignore-working-copy --color never log -r '::@ & bookmarks()' -n 1 --no-graph -T 'if(self.bookmarks(), self.bookmarks(), "")' 2>/dev/null)
        if test $status -eq 0
            if test -n "$jj_bookmarks"
                printf ' %s' $jj_bookmarks
            else
                set -l jj_change (jj --ignore-working-copy --color never log -r @ -n 1 --no-graph -T 'change_id.short()' 2>/dev/null)
                if test $status -eq 0 -a -n "$jj_change"
                    printf ' %s' $jj_change
                end
            end
            return
        end
    end

    if functions -q fish_git_prompt
        printf '%s' (fish_git_prompt)
    end
end

function fish_prompt
    set -l last_status $status

    if test $last_status -ne 0
        set_color red
        printf '[%s] ' $last_status
    end

    set_color cyan
    printf '%s' (prompt_pwd)

    set -l vcs_prompt (fish_vcs_prompt)
    if test -n "$vcs_prompt"
        set_color yellow
        printf '%s' $vcs_prompt
    end

    set_color normal
    printf '\n'
    set_color green
    printf '> '
    set_color normal
end

if status is-interactive
    if command -q jj
        jj util completion fish | source
    end

    if command -q fzf
        fzf --fish | source
    end

    if functions -q nvm
        nvm use 22 >/dev/null 2>/dev/null
    else if test -s /opt/homebrew/opt/nvm/nvm.sh
        echo "nvm.fish is not installed; install plugins from ~/.config/fish/fish_plugins for Node version management." >&2
    end
end

set -gx PATH $HOME/Development/chalk/cli $PATH

ulimit -n 65536
