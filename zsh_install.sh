#!/bin/sh

sudo apt update && sudo apt install -y zsh && chsh -s $(which zsh)
cp -r .zsh ~
cp .zshrc ~
cp -r zsh-syntax-highlighting ~
zsh
