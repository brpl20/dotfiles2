#!/bin/bash
# Dotfiles2 Bash additions for Arch Linux
# This file sources all necessary aliases and sets up the environment

DOTFILES_DIR="/home/brpl/code/dotfiles2"

# Set up Arch-specific environment variables
export GD="/home/brpl/gd"
export ESPANSO=""
export OD="/home/brpl/od"
export CODEF="/home/brpl/code"
export DESK="/home/brpl/Desktop"
export DOWN="/home/brpl/Downloads"
export BIGDOWN="/home/brpl/DOWNLOADS"
export EDITOR="nvim"
export EDITOR2="obsidian"

# Source alias files using symlinks in home directory
[[ -f "$HOME/.aliases-base" ]] && source "$HOME/.aliases-base"
[[ -f "$HOME/.aliases-git" ]] && source "$HOME/.aliases-git"
[[ -f "$HOME/.aliases-linux" ]] && source "$HOME/.aliases-linux"

echo "Olá Bruno! Não se equeça de fazer esse o melhor dia de sua vida! Memento Mori"
