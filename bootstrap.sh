#!/usr/bin/env zsh

cd "$(dirname "$0")"
pwd

echo 'Creating Symlinks'

echo '~/.config/zsh/zshrc.zsh'
ln -s $(pwd)/zsh/.zshrc ~/.zshrc

echo '~/.gitconfig'
ln -s $(pwd)/git/.gitconfig ~/.gitconfig

