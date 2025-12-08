#!/bin/bash
# Non-destructive installer for dotfiles on Arch Linux
# This script adds a single source line to your .bashrc - nothing else is modified
#
# Usage: ./install.sh [--uninstall]

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BASHRC="$HOME/.bashrc"
SOURCE_LINE="source $SCRIPT_DIR/bashrc-additions.sh"
MARKER="# >>> dotfiles2 >>>"
MARKER_END="# <<< dotfiles2 <<<"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

print_status() { echo -e "${GREEN}[✓]${NC} $1"; }
print_warning() { echo -e "${YELLOW}[!]${NC} $1"; }
print_error() { echo -e "${RED}[✗]${NC} $1"; }

check_dependencies() {
    echo "Checking optional dependencies..."

    local missing=()

    # Check for recommended packages
    command -v fzf &>/dev/null || missing+=("fzf")
    command -v starship &>/dev/null || missing+=("starship")
    command -v eza &>/dev/null || missing+=("eza")
    command -v fd &>/dev/null || missing+=("fd")

    # Clipboard tools
    if [[ -n "$WAYLAND_DISPLAY" ]]; then
        command -v wl-copy &>/dev/null || missing+=("wl-clipboard")
    else
        command -v xclip &>/dev/null || missing+=("xclip")
    fi

    if [[ ${#missing[@]} -gt 0 ]]; then
        print_warning "Optional packages not found: ${missing[*]}"
        echo ""
        echo "Install them with:"
        echo "  sudo pacman -S ${missing[*]}"
        echo ""
        echo "Or with yay (for AUR packages like starship):"
        echo "  yay -S ${missing[*]}"
        echo ""
    else
        print_status "All recommended packages are installed"
    fi
}

backup_bashrc() {
    local backup="$BASHRC.backup.$(date +%Y%m%d_%H%M%S)"
    cp "$BASHRC" "$backup"
    print_status "Backed up .bashrc to $backup"
}

is_installed() {
    grep -q "$MARKER" "$BASHRC" 2>/dev/null
}

install() {
    echo ""
    echo "=========================================="
    echo "  Dotfiles2 Installer for Arch Linux"
    echo "=========================================="
    echo ""

    # Check if already installed
    if is_installed; then
        print_warning "Dotfiles already installed in .bashrc"
        echo "Run with --uninstall to remove, or manually edit ~/.bashrc"
        exit 0
    fi

    # Check dependencies
    check_dependencies

    # Backup existing bashrc
    backup_bashrc

    # Add source line to bashrc
    echo "" >> "$BASHRC"
    echo "$MARKER" >> "$BASHRC"
    echo "# Dotfiles2 - Custom aliases and functions" >> "$BASHRC"
    echo "# To uninstall: ~/code/dotfiles2/arch/install.sh --uninstall" >> "$BASHRC"
    echo "$SOURCE_LINE" >> "$BASHRC"
    echo "$MARKER_END" >> "$BASHRC"

    print_status "Added dotfiles source line to ~/.bashrc"

    echo ""
    echo "=========================================="
    echo "  Installation Complete!"
    echo "=========================================="
    echo ""
    echo "To activate now, run:"
    echo "  source ~/.bashrc"
    echo ""
    echo "Or simply open a new terminal."
    echo ""
    echo "Files installed:"
    echo "  - $SCRIPT_DIR/aliases-git.sh"
    echo "  - $SCRIPT_DIR/aliases-linux.sh"
    echo "  - $SCRIPT_DIR/bashrc-additions.sh"
    echo ""
    echo "Your original .bashrc was backed up."
    echo ""
}

uninstall() {
    echo ""
    echo "=========================================="
    echo "  Uninstalling Dotfiles2"
    echo "=========================================="
    echo ""

    if ! is_installed; then
        print_warning "Dotfiles not found in .bashrc - nothing to uninstall"
        exit 0
    fi

    # Backup before uninstall
    backup_bashrc

    # Remove the block between markers
    sed -i "/$MARKER/,/$MARKER_END/d" "$BASHRC"

    # Remove any trailing empty lines
    sed -i -e :a -e '/^\n*$/{$d;N;ba' -e '}' "$BASHRC"

    print_status "Removed dotfiles from ~/.bashrc"
    echo ""
    echo "Uninstall complete. Restart your terminal or run:"
    echo "  source ~/.bashrc"
    echo ""
}

show_help() {
    echo "Dotfiles2 Installer for Arch Linux"
    echo ""
    echo "Usage: $0 [OPTION]"
    echo ""
    echo "Options:"
    echo "  (none)       Install dotfiles (adds source line to .bashrc)"
    echo "  --uninstall  Remove dotfiles from .bashrc"
    echo "  --check      Check if dependencies are installed"
    echo "  --help       Show this help message"
    echo ""
    echo "This installer is non-destructive:"
    echo "  - Only adds a single source line to your .bashrc"
    echo "  - Creates a backup before any changes"
    echo "  - Does not modify any other system files"
    echo "  - Works alongside your existing Omarchy setup"
}

case "${1:-}" in
    --uninstall)
        uninstall
        ;;
    --check)
        check_dependencies
        ;;
    --help|-h)
        show_help
        ;;
    "")
        install
        ;;
    *)
        print_error "Unknown option: $1"
        show_help
        exit 1
        ;;
esac
