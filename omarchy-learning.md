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

---

## LazyVim - Search & Find

### Find Files
| Key | Action |
|-----|--------|
| `<leader>ff` | Find files (root dir) |
| `<leader><space>` | Find files (root dir) |
| `<leader>fF` | Find files (cwd) |
| `<leader>fr` | Recent files |

### Buffer Search
| Key | Action |
|-----|--------|
| `<leader>sb` | Search buffer (fuzzy find in current buffer) |
| `<leader>/` | Grep (search in files) |
| `<leader>sg` | Grep (search in files) |
| `<leader>sG` | Grep (cwd) |
| `<leader>sw` | Search word under cursor |

### Grep Tips
- Use `<leader>/` then type to search all files
- Results open in Telescope, press `Enter` to jump to match
- `<C-q>` sends results to quickfix list for batch editing

---

## LazyVim - Text Objects (Delete Inside)

### Delete Inside Quotes/Brackets
| Key | Action |
|-----|--------|
| `di'` | Delete inside single quotes |
| `di"` | Delete inside double quotes |
| `di`` ` | Delete inside backticks |
| `di(` or `dib` | Delete inside parentheses |
| `di[` | Delete inside brackets |
| `di{` or `diB` | Delete inside braces |
| `dit` | Delete inside HTML tag |

### Change Inside (Same patterns)
| Key | Action |
|-----|--------|
| `ci'` | Change inside single quotes |
| `ci"` | Change inside double quotes |
| `ci(` | Change inside parentheses |

### Yank Inside
| Key | Action |
|-----|--------|
| `yi'` | Yank inside single quotes |
| `yi"` | Yank inside double quotes |

### Around (includes the quotes/brackets)
| Key | Action |
|-----|--------|
| `da'` | Delete around single quotes (includes ') |
| `da"` | Delete around double quotes (includes ") |
| `da(` | Delete around parentheses |

---

## TMUX

### Config File
- Config: `~/.tmux.conf`
- Reload config: `tmux source-file ~/.tmux.conf`

### Split Navigation (Add to ~/.tmux.conf)
```bash
# Split navigation with s + hjkl (similar to arrows)
bind -n M-h select-pane -L
bind -n M-l select-pane -R
bind -n M-k select-pane -U
bind -n M-j select-pane -D

# Or with prefix + hjkl
bind h select-pane -L
bind l select-pane -R
bind k select-pane -U
bind j select-pane -D
```

### Custom sl, sh, sj, sk Navigation
Add to `~/.tmux.conf`:
```bash
# Use 's' as secondary prefix for pane navigation
# sh = left, sl = right, sj = down, sk = up
bind -n C-s switch-client -T pane_nav
bind -T pane_nav h select-pane -L
bind -T pane_nav l select-pane -R
bind -T pane_nav j select-pane -D
bind -T pane_nav k select-pane -U
```
Usage: Press `Ctrl+s` then `h/j/k/l` to navigate panes

### Basic Pane Management
| Key | Action |
|-----|--------|
| `Prefix + %` | Split vertical |
| `Prefix + "` | Split horizontal |
| `Prefix + x` | Close pane |
| `Prefix + z` | Toggle pane zoom |
| `Prefix + {` / `}` | Swap pane left/right |

### Session with 5 Most Used Layouts
Create `~/.tmux/dev-session.sh`:
```bash
#!/bin/bash
SESSION="dev"

tmux new-session -d -s $SESSION -n "editor"

# Window 1: Editor (main)
tmux send-keys -t $SESSION:1 'nvim' C-m

# Window 2: Terminal split (horizontal)
tmux new-window -t $SESSION:2 -n "term"
tmux split-window -h -t $SESSION:2

# Window 3: Logs (vertical splits)
tmux new-window -t $SESSION:3 -n "logs"
tmux split-window -v -t $SESSION:3

# Window 4: Git
tmux new-window -t $SESSION:4 -n "git"
tmux send-keys -t $SESSION:4 'lazygit' C-m

# Window 5: Server/Docker
tmux new-window -t $SESSION:5 -n "server"

# Attach to session
tmux attach-session -t $SESSION
```
Run with: `bash ~/.tmux/dev-session.sh`

### Quick Session Commands
| Command | Action |
|---------|--------|
| `tmux new -s name` | New session |
| `tmux ls` | List sessions |
| `tmux attach -t name` | Attach to session |
| `Prefix + d` | Detach |
| `Prefix + s` | Switch session |
