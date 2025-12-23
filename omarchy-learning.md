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
| `Super+Shift+R` | Reload Hyprland config |

### Move Window to Workspace
| Key | Action |
|-----|--------|
| `Super+Shift+[1-0]` | Move window to workspace 1–10 |
| `Super+Shift+Alt+[1-0]` | Move window silently to workspace 1–10 (stay on current workspace) |
| `Super+Shift+,` | Move window to previous workspace |
| `Super+Shift+.` | Move window to next workspace |

### Config Files
- Main config: `~/.config/hypr/hyprland.conf`
- Look & feel: `~/.config/hypr/looknfeel.conf`
- Keybindings: `~/.config/hypr/bindings.conf`

### Workspace Animations
Edit `~/.config/hypr/looknfeel.conf`:
```bash
animations {
    bezier = fastSlide, 0.2, 1, 0.3, 1
    animation = workspaces, 1, 2, fastSlide, slide
}
```
- Speed: `2` (lower = faster)
- Styles: `slide`, `slidevert`, `fade`, `slidefade`

---

## Waybar (Top Bar)

### Config Files
- Config: `~/.config/waybar/config.jsonc`
- Style: `~/.config/waybar/style.css`

### Reload Waybar
```bash
killall waybar && waybar &
```

### Custom Workspace Colors
Edit `~/.config/waybar/style.css`:
```css
/* RED / RED Shade / BLUE / BLUE Shade / GREEN / GREEN Shade */
#workspaces button:nth-child(1) { color: #ff4444; }
#workspaces button:nth-child(2) { color: #aa2222; }
#workspaces button:nth-child(3) { color: #4488ff; }
#workspaces button:nth-child(4) { color: #2255aa; }
#workspaces button:nth-child(5) { color: #44dd44; }
#workspaces button:nth-child(6) { color: #228822; }
```

---

## LazyVim - Navigation (Moving Multiple Lines)

### By Count
| Key | Action |
|-----|--------|
| `10j` / `10k` | Move 10 lines down/up (use relative line numbers) |

### Half/Full Page
| Key | Action |
|-----|--------|
| `Ctrl+d` / `Ctrl+u` | Half page down/up |
| `Ctrl+f` / `Ctrl+b` | Full page down/up |

### Screen Positions
| Key | Action |
|-----|--------|
| `H` | Top of screen (High) |
| `M` | Middle of screen |
| `L` | Bottom of screen (Low) |

### File Positions
| Key | Action |
|-----|--------|
| `gg` | Top of file |
| `G` | Bottom of file |
| `50G` or `:50` | Go to line 50 |

### Paragraph Navigation
| Key | Action |
|-----|--------|
| `}` | Jump to next blank line |
| `{` | Jump to previous blank line |

---

## Git Tips

### Pull with Modified Files
```bash
git pull --autostash
```
Automatically stashes changes, pulls, then reapplies them.

---

## fzf - Fuzzy Finder

### Multi-Select Files
Enable multi-select mode with `-m` flag:
```bash
fzf -m
```

### Selection Keys
| Key | Action |
|-----|--------|
| `Tab` | Toggle selection on current item |
| `Shift+Tab` | Toggle selection and move up |

### Copy Multiple Paths to Clipboard
```bash
# X11
fzf -m | xclip -selection clipboard

# Wayland
fzf -m | wl-copy

# With fd (find files and copy paths)
fd -t f | fzf -m | wl-copy
```

### Useful Combinations
```bash
# Find and copy paths (space-separated)
fd -t f | fzf -m | tr '\n' ' ' | wl-copy

# Open multiple files in nvim
nvim $(fzf -m)

# Preview files while selecting
fzf -m --preview 'bat --color=always {}'
```
