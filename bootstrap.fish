!/usr/bin/env fish

set -l system_type (uname -s)

echo 'Creating symlinks...'

echo '  * ~/.zshrc'
if [ ! -f "$HOME/.zshrc" ]; then
   ln -s $(pwd)/zsh/.zshrc ~/.zshrc
end

echo '  * ~/.config/fish/fish.config'
if [ ! -d "$HOME/.config/fish" ]; then
   ln -s (pwd)/fish/config.fish ~/.config/fish/config.fish
end

echo '  * ~/.config/fish/functions'
if [ -d "$HOME/.config/fish/functions" ]
    echo  '~/.config/fish/functions already exists'
else
    ln -s (pwd)/fish/functions ~/.config/fish/functions
end

echo '  * ~/.gitconfig'
if [ ! -f "$HOME/.gitconfig" ]; then
   ln -s $(pwd)/git/.gitconfig ~/.gitconfig
end

echo '  * ~/.config/nvim'
if [ ! -f "$HOME/.config/nvim" ]; then
   ln -s $(pwd)/nvim ~/.config/nvim
end

set -l lazygit_dir="$HOME/.config/lazygit"
if [ "$system_type" = "Darwin" ]; then
    set lazygit_dir="$HOME/Library/Application Support/lazygit/"
end
echo "  * $lazygit_dir"
if [ ! -f "$lazygit_dir/config.yml" ]; then
   ln -s $(pwd)/lazygit/config.yml "$lazygit_dir/config.yml"
end

echo '  * ~/.config/helix'
if [ ! -f "$HOME/.config/helix" ]; then
   ln -s $(pwd)/helix ~/.config/helix
end




