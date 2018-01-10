#!/usr/bin/env fish

cd (dirname (status -f))
pwd

echo 'Creating Symlinks'

echo '~/.config/fish/config.fish'
ln -s (pwd)/fish/config.fish ~/.config/fish/config.fish

echo '~/.gitconfig'
ln -s (pwd)/git/.gitconfig ~/.gitconfig

