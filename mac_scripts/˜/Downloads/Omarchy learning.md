# Omarchy Learning

## Alacritty - Copy Text Using Keyboard Only

### Enable Vi Mode
Press `Ctrl+Shift+Space` to enter Vi mode

### In Vi Mode
1. Navigate with `h`, `j`, `k`, `l` (or arrow keys)
2. Press `v` to start visual selection
3. Move to select text
4. Press `y` to yank (copy) to clipboard

### Exit Vi Mode
Try these options:
- `Escape`
- `Ctrl+Shift+Space`
- `i`
- `Enter` (after yanking)
- `Ctrl+c` (force cancel)

### Quick Copy Shortcuts
| Shortcut | Action |
|----------|--------|
| `Ctrl+Shift+C` | Copy selected text |
| `Ctrl+Shift+V` | Paste |

### Useful Vi Mode Commands
| Command | Action |
|---------|--------|
| `w` / `b` | Jump word forward/backward |
| `0` / `$` | Jump to line start/end |
| `gg` / `G` | Jump to top/bottom |
| `v` | Start character selection |
| `V` | Select entire lines |
| `/` | Search forward |
| `?` | Search backward |
| `n` / `N` | Next/previous search match |

### Custom Keybindings
You can customize keybindings in `~/.config/alacritty/alacritty.toml`

---

## LazyVim - File Explorer (Neo-tree)

### Toggle File Explorer
| Key | Action |
|-----|--------|
| `Space + e` | Toggle file explorer (focus it) |
| `Space + E` | Toggle file explorer (cwd) |

### Neo-tree Navigation
| Key | Action |
|-----|--------|
| `a` | Add file/folder |
| `d` | Delete |
| `r` | Rename |
| `c` | Copy |
| `m` | Move |
| `y` | Copy path |
| `p` | Paste |
| `Enter` | Open file |
| `s` | Open in split |
| `q` | Close neo-tree |

---

## LazyVim - Buffers & Tabs

### Buffer Navigation (Tab Bar)
| Key | Action |
|-----|--------|
| `Shift+h` | Previous buffer |
| `Shift+l` | Next buffer |
| `<leader>bb` | Switch buffer (picker) |
| `<leader>bd` | Delete buffer |
| `<leader>bo` | Delete other buffers |
| `<leader>bp` | Toggle pin buffer |
| `<leader>,` | Switch buffer (fuzzy) |

### Vim Tabs
| Key | Action |
|-----|--------|
| `gt` | Next tab |
| `gT` | Previous tab |
| `<leader><tab>d` | Close tab |
| `<leader><tab>]` | Next tab |
| `<leader><tab>[` | Previous tab |

---

## Hyprland

### Window Management
| Key | Action |
|-----|--------|
| `Shift+Super+Backspace` | Remove gaps between windows |
