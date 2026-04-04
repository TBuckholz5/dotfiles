#!/bin/bash

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

    ln -s "$src" "$dest"
    echo "Linked $dest -> $src"
}

link "$DOTFILES/.tmux.conf"      ~/.tmux.conf
link "$DOTFILES/nvim"            ~/.config/nvim
link "$DOTFILES/.vimrc"          ~/.vimrc
link "$DOTFILES/.aerospace.toml" ~/.aerospace.toml
link "$DOTFILES/.zshrc"          ~/.zshrc
link "$DOTFILES/zellij"          ~/.config/zellij
