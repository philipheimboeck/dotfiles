#!/usr/bin/env fish

cd (dirname (status -f))
pwd

echo 'Creating Symlinks'

ln -s (pwd)/git/.gitconfig ~/.gitconfig

