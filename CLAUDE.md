# Dotfiles2 Structure

Personal dotfiles repository for multi-machine setup (macOS and Linux).

## Directory Structure

```
dotfiles2/
├── zshrc                     # Single entry point (symlinked to ~/.zshrc)
├── os/
│   ├── darwin                # macOS: pbcopy, open, edespanso, homebrew, paths
│   └── linux                 # Linux: xclip, xdg-open, ls --color
├── machines/
│   ├── macbook               # Exports: EDITOR, GD, NC, OD, CODEF, DESK, DOWN, UTEIS
│   ├── mac-mini              # Same + BIGDOWN, ssd alias
│   ├── debian                # Linux paths + code editor
│   ├── arch                  # Linux paths + nvim editor
│   └── server                # Minimal (vim only)
├── aliases/
│   ├── aliases-base          # Shared aliases (ss uses $UTEIS, $CLIP)
│   └── aliases-git           # Git aliases (sourced by zshrc)
├── espanso/
│   └── base.yml              # Espanso text expander config
├── shell/                    # Utility scripts
├── gitup.sh                  # General-purpose quick git push script
```

## Configuration Flow

### Sourcing chain in `zshrc`:
```
1. oh-my-zsh, nvm, rbenv, pyenv, atuin, fzf, starship
2. machines/<name>       (from ~/.machine — sets EDITOR, CODEF, GD, UTEIS, etc.)
3. os/darwin OR os/linux (via uname — sets CLIP, pwdc, edespanso, paths)
4. aliases/aliases-base  (shared aliases)
5. aliases/aliases-git   (git aliases)
```

### Environment Variables (set by machines/ files)
- `EDITOR` - Primary editor (zed on mac, nvim on arch, etc.)
- `EDITOR2` - Secondary/fallback editor
- `CODEF` - Code folder path
- `GD` - Google Drive path
- `OD` - OneDrive path
- `NC` - Nextcloud path
- `UTEIS` - Path to uteis notes file (used by `ss` function)
- `CLIP` - Clipboard command (set by os/ files: pbcopy or xclip)

## Espanso Setup

The espanso config lives in this repo and is symlinked to the system location:

```
~/Library/Application Support/espanso/match/base.yml -> $CODEF/dotfiles2/espanso/base.yml
```

```
ln -sf $CODEF/dotfiles2/espanso/base.yml ~/Library/Application\ Support/espanso/match/base.yml
edespanso
```

### Editing Espanso
```bash
edespanso  # Opens base.yml in $EDITOR and restarts espanso (macOS only)
```

## Setup Per Machine (one-time)

```bash
echo "macbook" > ~/.machine                # set machine identity
ln -sf ~/code/dotfiles2/zshrc ~/.zshrc     # single symlink needed

# Espanso (macOS only)
ln -sf $CODEF/dotfiles2/espanso/base.yml ~/Library/Application\ Support/espanso/match/base.yml
```

## gitup.sh (gup)

General-purpose quick git push for simple repos (blogs, notes, etc.):
```bash
gup              # pull + add + commit "auto-update" + push
gup "my message" # pull + add + commit "my message" + push
```
