#!/bin/sh

rm ~/.zshrc
rm -r ~/.zsh
rm ~/.zsh_history
rm -r ~/zsh-syntax-highlighting

chsh -s $(which bash)
sudo apt --purge remove zsh
bash
