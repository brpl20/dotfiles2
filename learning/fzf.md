# fzf - Fuzzy Finder

## Multi-Select Files
Enable multi-select mode with `-m` flag:
```bash
fzf -m
```

## Selection Keys
| Key | Action |
|-----|--------|
| `Tab` | Toggle selection on current item |
| `Shift+Tab` | Toggle selection and move up |

## Copy Multiple Paths to Clipboard
```bash
# X11
fzf -m | xclip -selection clipboard

# Wayland
fzf -m | wl-copy

# With fd (find files and copy paths)
fd -t f | fzf -m | wl-copy
```

## Useful Combinations
```bash
# Find and copy paths (space-separated)
fd -t f | fzf -m | tr '\n' ' ' | wl-copy

# Open multiple files in nvim
nvim $(fzf -m)

# Preview files while selecting
fzf -m --preview 'bat --color=always {}'
```
