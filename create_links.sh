#!/bin/bash

set -e

DOTFILES=~/dotfiles

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

if ! command -v brew &>/dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

BREW_PACKAGES=(
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
link "$DOTFILES/zellij"          ~/.config/zellij
link "$DOTFILES/bin/zellij-sessionizer" ~/.local/bin/zellij-sessionizer
link "$DOTFILES/bin/zellij-file-finder" ~/.local/bin/zellij-file-finder

echo "Done."
