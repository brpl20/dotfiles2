# TMUX

## Config File
- Config: `~/.tmux.conf`
- Reload config: `tmux source-file ~/.tmux.conf`

## Split Navigation (Add to ~/.tmux.conf)
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

## Custom sl, sh, sj, sk Navigation
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

## Basic Pane Management
| Key | Action |
|-----|--------|
| `Prefix + %` | Split vertical |
| `Prefix + "` | Split horizontal |
| `Prefix + x` | Close pane |
| `Prefix + z` | Toggle pane zoom |
| `Prefix + {` / `}` | Swap pane left/right |

## Session with 5 Most Used Layouts
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

## Quick Session Commands
| Command | Action |
|---------|--------|
| `tmux new -s name` | New session |
| `tmux ls` | List sessions |
| `tmux attach -t name` | Attach to session |
| `Prefix + d` | Detach |
| `Prefix + s` | Switch session |
