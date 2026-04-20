#!/bin/bash

set -e

DOTFILES=~/dotfiles
FISH_CONFIG_DIR=~/.config/fish
FISH_CONFIG_FILE="$FISH_CONFIG_DIR/config.fish"
FISH_CONFIG_BACKUP="$FISH_CONFIG_DIR/config.fish.backup"

link() {
    local src=$1
    local dest=$2

    if [ -L "$dest" ]; then
        rm "$dest"
    elif [ -e "$dest" ]; then
        echo "WARNING: $dest exists and is not a symlink, skipping"
        return
    fi

    mkdir -p "$(dirname "$dest")"
    ln -s "$src" "$dest"
    echo "Linked $dest -> $src"
}

backup_fish_config() {
    if [ -f "$FISH_CONFIG_FILE" ] && [ ! -L "$FISH_CONFIG_FILE" ]; then
        local backup_target="$FISH_CONFIG_BACKUP"

        if [ -e "$backup_target" ]; then
            backup_target="$FISH_CONFIG_BACKUP-$(date +%Y%m%d%H%M%S)"
        fi

        mv "$FISH_CONFIG_FILE" "$backup_target"
        echo "Backed up $FISH_CONFIG_FILE -> $backup_target"
    fi
}

install_fish_plugins() {
    mkdir -p "$FISH_CONFIG_DIR/functions"

    if [ ! -f "$FISH_CONFIG_DIR/functions/fisher.fish" ]; then
        echo "Installing fisher..."
        curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish \
            -o "$FISH_CONFIG_DIR/functions/fisher.fish"
    fi

    echo "Installing fish plugins..."
    fish -c "fisher install (string split '\n' < \"$FISH_CONFIG_DIR/fish_plugins\")"
}

if ! command -v brew &>/dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

BREW_PACKAGES=(
    fish
    git
    neovim
    tmux
    zellij
    lazygit
    jj
    jjui
    fzf
    fd
    ripgrep
    eza
    go
    buf
)

BREW_CASKS=(
    aerospace
)

echo "Installing brew packages..."
for pkg in "${BREW_PACKAGES[@]}"; do
    if brew list "$pkg" &>/dev/null; then
        echo "  $pkg already installed"
    else
        echo "  Installing $pkg..."
        brew install "$pkg"
    fi
done

echo "Installing brew casks..."
for cask in "${BREW_CASKS[@]}"; do
    if brew list --cask "$cask" &>/dev/null; then
        echo "  $cask already installed"
    else
        echo "  Installing $cask..."
        brew install --cask "$cask"
    fi
done

link "$DOTFILES/.tmux.conf"      ~/.tmux.conf
link "$DOTFILES/nvim"            ~/.config/nvim
link "$DOTFILES/.vimrc"          ~/.vimrc
link "$DOTFILES/.aerospace.toml" ~/.aerospace.toml
link "$DOTFILES/.zshrc"          ~/.zshrc
backup_fish_config
link "$DOTFILES/fish/config.fish" ~/.config/fish/config.fish
link "$DOTFILES/fish/fish_plugins" ~/.config/fish/fish_plugins
link "$DOTFILES/zellij"          ~/.config/zellij
link "$DOTFILES/bin/zellij-sessionizer" ~/.local/bin/zellij-sessionizer
link "$DOTFILES/bin/zellij-file-finder" ~/.local/bin/zellij-file-finder

install_fish_plugins

echo "Done."
