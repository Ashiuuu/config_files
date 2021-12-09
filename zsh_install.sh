#!/bin/sh

sudo apt update && sudo apt install -y zsh && chsh -s $(which zsh)
mkdir .zsh
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
cp .zshrc ~
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/zsh-syntax-highlighting
echo "source ~/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ~/.zshrc
echo "zsh" >> .bashrc
zsh
