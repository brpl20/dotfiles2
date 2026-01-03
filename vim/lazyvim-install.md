# LazyVim Installation Guide

## Requirements

- Neovim >= 0.9.0 (built with LuaJIT)
- Git
- A Nerd Font (optional, for icons)
- A C compiler for nvim-treesitter

## macOS Installation

### 1. Install Neovim

```bash
brew install neovim
```

### 2. Backup existing config (if any)

```bash
mv ~/.config/nvim{,.bak}
mv ~/.local/share/nvim{,.bak}
mv ~/.local/state/nvim{,.bak}
mv ~/.cache/nvim{,.bak}
```

### 3. Clone LazyVim starter

```bash
git clone https://github.com/LazyVim/starter ~/.config/nvim
```

### 4. Remove .git directory

```bash
rm -rf ~/.config/nvim/.git
```

### 5. Launch Neovim

```bash
nvim
```

Plugins will install automatically on first launch.

### 6. Verify installation

Inside Neovim, run:
```
:LazyHealth
```

## Linux Installation

### 1. Install Neovim

**Ubuntu/Debian:**
```bash
sudo apt update
sudo apt install neovim
```

**Fedora:**
```bash
sudo dnf install neovim
```

**Arch:**
```bash
sudo pacman -S neovim
```

### 2-6. Follow macOS steps 2-6 above

## Windows Installation (PowerShell)

### 1. Install Neovim

```powershell
winget install Neovim.Neovim
```

### 2. Backup existing config

```powershell
Move-Item $env:LOCALAPPDATA\nvim $env:LOCALAPPDATA\nvim.bak
Move-Item $env:LOCALAPPDATA\nvim-data $env:LOCALAPPDATA\nvim-data.bak
```

### 3. Clone LazyVim starter

```powershell
git clone https://github.com/LazyVim/starter $env:LOCALAPPDATA\nvim
```

### 4. Remove .git directory

```powershell
Remove-Item $env:LOCALAPPDATA\nvim\.git -Recurse -Force
```

### 5. Launch Neovim

```powershell
nvim
```

## Optional: Install Nerd Font

For icons to display correctly:

**macOS:**
```bash
brew install --cask font-hack-nerd-font
```

**Linux:**
Download from https://www.nerdfonts.com/ and install manually.

**Windows:**
```powershell
winget install DEVCOM.JetBrainsMonoNerdFont
```

Then configure your terminal to use the Nerd Font.

## Useful Commands

| Command | Description |
|---------|-------------|
| `:Lazy` | Open lazy.nvim plugin manager |
| `:LazyHealth` | Check installation health |
| `:LazyUpdate` | Update all plugins |
| `:Mason` | Manage LSP servers, linters, formatters |

## Configuration

Your config lives in `~/.config/nvim/lua/`:
- `config/lazy.lua` - Plugin manager settings
- `config/options.lua` - Neovim options
- `config/keymaps.lua` - Key mappings
- `plugins/` - Add custom plugins here

## Resources

- Official docs: https://www.lazyvim.org
- GitHub: https://github.com/LazyVim/LazyVim
- Starter template: https://github.com/LazyVim/starter
