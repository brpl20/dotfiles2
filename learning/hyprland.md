# Hyprland

## Window Management
| Key | Action |
|-----|--------|
| `Shift+Super+Backspace` | Remove gaps between windows |
| `Super+Shift+R` | Reload Hyprland config |

## Move Window to Workspace
| Key | Action |
|-----|--------|
| `Super+Shift+[1-0]` | Move window to workspace 1-10 |
| `Super+Shift+Alt+[1-0]` | Move window silently to workspace 1-10 (stay on current workspace) |
| `Super+Shift+,` | Move window to previous workspace |
| `Super+Shift+.` | Move window to next workspace |

## Config Files
- Main config: `~/.config/hypr/hyprland.conf`
- Look & feel: `~/.config/hypr/looknfeel.conf`
- Keybindings: `~/.config/hypr/bindings.conf`

## Workspace Animations
Edit `~/.config/hypr/looknfeel.conf`:
```bash
animations {
    bezier = fastSlide, 0.2, 1, 0.3, 1
    animation = workspaces, 1, 2, fastSlide, slide
}
```
- Speed: `2` (lower = faster)
- Styles: `slide`, `slidevert`, `fade`, `slidefade`
