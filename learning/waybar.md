# Waybar (Top Bar)

## Config Files
- Config: `~/.config/waybar/config.jsonc`
- Style: `~/.config/waybar/style.css`

## Reload Waybar
```bash
killall waybar && waybar &
```

## Custom Workspace Colors
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
