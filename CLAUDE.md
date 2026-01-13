# Dotfiles2 Structure

Personal dotfiles repository for multi-machine setup (macOS and Linux).

## Directory Structure

```
dotfiles2/
├── aliases/           # Shell aliases (machine-specific)
│   ├── aliases-base   # Shared aliases (all machines)
│   ├── aliases-macbook
│   ├── aliases-mac-mini
│   ├── aliases-linux
│   └── aliases-git
├── espanso/           # Espanso text expander config
│   └── base.yml       # Source of truth for espanso matches
├── shell_scripts/     # Utility scripts
├── zshrc-mac          # Mac zsh config
├── zshrc-minimal      # Minimal zsh config
└── env                # Environment variables reference (draft)
```

## Configuration Flow

### macOS
1. `~/.zshrc` sources `zshrc-mac`
2. `zshrc-mac` sets environment variables (EDITOR, CODEF, GD, etc.)
3. Sources `~/.aliases-mac` (symlinked to `aliases/aliases-macbook` or `aliases-mac-mini`)
4. Sources `~/.aliases-base` (symlinked to `aliases/aliases-base`)

### Environment Variables (Mac)
- `EDITOR=zed` - Primary editor
- `EDITOR2=vim` - Secondary/fallback editor
- `CODEF` - Code folder path
- `GD` - Google Drive path
- `OD` - OneDrive path

## Espanso Setup

The espanso config lives in this repo and is symlinked to the system location:

```
~/Library/Application Support/espanso/match/base.yml -> $CODEF/dotfiles2/espanso/base.yml
```

### Editing Espanso
```bash
edespanso  # Opens base.yml in $EDITOR and restarts espanso
```

## Symlinks Required

Create these symlinks for a new machine:

```bash
# Aliases
ln -sf $CODEF/dotfiles2/aliases/aliases-base ~/.aliases-base
ln -sf $CODEF/dotfiles2/aliases/aliases-macbook ~/.aliases-mac  # or aliases-mac-mini

# Espanso
ln -sf $CODEF/dotfiles2/espanso/base.yml ~/Library/Application\ Support/espanso/match/base.yml
```
