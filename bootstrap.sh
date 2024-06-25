#!/usr/bin/env zsh

system_type=$(uname -s)

install_brew() {
  
  # install homebrew if it's missing
  if ! command -v brew >/dev/null 2>&1; then
    echo "Installing homebrew..."
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  fi

  if [ -f "$HOME/.Brewfile" ]; then
    echo "Updating homebrew bundle..."
    brew bundle --global
  fi
}

cd "$(dirname "$0")"
pwd

echo 'Creating Symlinks...'

echo '  * ~/.zshrc'
if [ ! -f "$HOME/.zshrc" ]; then
   ln -s $(pwd)/zsh/.zshrc ~/.zshrc
fi

echo '  * ~/.gitconfig'
if [ ! -f "$HOME/.gitconfig" ]; then
   ln -s $(pwd)/git/.gitconfig ~/.gitconfig
fi

echo '  * ~/.config/nvim'
if [ ! -f "$HOME/.config/nvim" ]; then
   ln -s $(pwd)/nvim ~/.config/nvim
fi


echo ""

## OSX
if [ "$system_type" = "Darwin" ]; then
  install_brew
fi

