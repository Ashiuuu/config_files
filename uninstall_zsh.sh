#!/bin/sh

rm ~/.zshrc
rm -rf ~/.zsh
rm ~/.zsh_history
rm -rf ~/zsh-syntax-highlighting

chsh -s $(which bash)
sudo apt --purge remove zsh
bash
