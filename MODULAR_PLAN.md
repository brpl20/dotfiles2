# Modular Dotfiles Restructure

## Problem
- `~/.zshrc` and `dotfiles2/zshrc-mac` are separate files that drift apart
- Machine-specific stuff is mixed with OS-specific stuff in big `if/else` blocks
- `aliases-git` (299 lines) is never sourced
- Same `ss` function is copy-pasted 3 times with only the file path different
- Same `pwdc`/`edespanso` duplicated across macbook, mac-mini, linux aliases

## New Structure

```
dotfiles2/
├── zshrc                     # Single entry point (symlinked to ~/.zshrc)
├── os/
│   ├── darwin                # macOS: homebrew, pbcopy, open, espanso restart
│   └── linux                 # Linux: ls --color, xclip
├── machines/
│   ├── macbook               # Exports: EDITOR, GD, NC, OD, CODEF, DESK, DOWN, UTEIS
│   ├── mac-mini              # Same + BIGDOWN, ssd alias
│   ├── debian                # Linux paths + editors
│   ├── arch                  # Linux paths + editors
│   └── server                # Minimal
├── aliases/
│   ├── aliases-base          # Shared aliases (updated: ss uses $UTEIS, pwdc uses $CLIP)
│   └── aliases-git           # Git aliases (finally sourced)
├── espanso/
│   └── base.yml
```

## How It Works

**Machine identity** — one-time setup per machine:
```bash
echo "macbook" > ~/.machine
ln -sf ~/code/dotfiles2/zshrc ~/.zshrc
```

**Sourcing chain** in `zshrc`:
```
1. oh-my-zsh, nvm, rbenv, pyenv, atuin (common tools)
2. os/darwin OR os/linux       (detected via `uname`)
3. machines/<name>             (read from ~/.machine)
4. aliases/aliases-base        (shared aliases)
5. aliases/aliases-git         (git aliases)
```

No more `if/else` blocks in zshrc. No more symlinks for alias files. Only one symlink needed: `~/.zshrc`.

## Key Changes

### 1. `zshrc` (new, replaces both zshrc-mac and ~/.zshrc)
- All common setup (oh-my-zsh, version managers, atuin, encoding, PATH)
- Auto-detects OS via `uname`, sources `os/darwin` or `os/linux`
- Reads `~/.machine` for machine name, sources `machines/<name>`
- Sources aliases directly from repo (no more alias symlinks needed)
- File: `/Users/brpl20/code/dotfiles2/zshrc`

### 2. `os/darwin` (new)
- `alias pwdc='pwd | pbcopy'`
- `alias o="open ."`
- `alias edespanso="$EDITOR $CODEF/dotfiles2/espanso/base.yml && espanso restart"`
- homebrew settings, zsh-syntax-highlighting path, postgresql/llvm PATH
- Espanso symlink path

### 3. `os/linux` (new)
- `alias pwdc='pwd | xclip -selection clipboard'`
- `alias o="xdg-open ."`
- ls aliases with `--color=auto`
- zsh-syntax-highlighting path (`/usr/share/...`)

### 4. `machines/macbook` (new)
```bash
export EDITOR="zed"
export EDITOR2="vim"
export GD="/Users/brpl20/Library/CloudStorage/GoogleDrive-pelli.br@gmail.com/Meu Drive"
export NC="/Users/brpl20/nc"
export OD="/Users/brpl20/Library/CloudStorage/OneDrive-Pessoal"
export CODEF="/Users/brpl20/code"
export DESK="/Users/brpl20/Desktop"
export DOWN="/Users/brpl20/Downloads"
export UTEIS="$NC/wikit/daily/uteisNew.md"
```

### 5. `machines/mac-mini` (new)
Same as macbook but with:
```bash
export BIGDOWN="/Volumes/BPSSD/DOWNLOADS"
export UTEIS="/Volumes/BPSSD/gd/wikit/daily/uteisNew.md"
=> We can create an variable here for $gd 
alias ssd='cd /Volumes/BPSSD'
```

### 6. `machines/debian`, `machines/arch`, `machines/server` (new)
Linux-specific paths (from the env file draft).

### 7. `aliases/aliases-base` (modified)
- Remove duplicated `ss` function → replace with one that uses `$UTEIS`
- Remove `pwdc` → moved to os/ files
- Remove `edespanso` → moved to os/ files

### 8. Cleanup
- Delete old `aliases/aliases-macbook`, `aliases/aliases-mac-mini`, `aliases/aliases-linux`
- Delete old `zshrc-mac` (replaced by `zshrc`)
- Delete broken `env` file (replaced by machines/ files)
- Remove old symlinks (`~/.aliases-mac`, `~/.aliases-base`)

## Files Created (DONE)
- [x] `zshrc` — unified entry point
- [x] `os/darwin` — macOS: pbcopy, open, edespanso, homebrew, paths
- [x] `os/linux` — Linux: xclip, xdg-open, ls --color
- [x] `machines/macbook` — EDITOR, GD, NC, OD, CODEF, DESK, DOWN, UTEIS
- [x] `machines/mac-mini` — same + BIGDOWN, ssd alias
- [x] `machines/debian` — Linux paths, code editor
- [x] `machines/arch` — Linux paths, nvim editor
- [x] `machines/server` — minimal (vim only)
- [x] `aliases/aliases-base` — updated: ss uses $UTEIS, removed pwdc/edespanso
- [x] `gitup.sh` — rewritten as general-purpose gup (auto-detect branch, works from any repo)

## Sourcing Order (actual)
```
1. oh-my-zsh, nvm, rbenv, pyenv, atuin, fzf, starship (common tools)
2. machines/<name>             (read from ~/.machine — sets EDITOR, CODEF, GD, etc.)
3. os/darwin OR os/linux       (detected via uname — uses variables from step 2)
4. aliases/aliases-base        (shared aliases)
5. aliases/aliases-git         (git aliases — finally sourced!)
```

## Files to Delete (after verifying new setup works)
- `zshrc-mac`
- `zshrc-minimal`
- `aliases/aliases-macbook`
- `aliases/aliases-mac-mini`
- `aliases/aliases-linux`
- `env`

## Activation (one-time per machine)
```bash
echo "macbook" > ~/.machine
ln -sf ~/code/dotfiles2/zshrc ~/.zshrc
exec zsh
```

## Verification
1. Run `exec zsh` after symlinking
2. Check `echo $NC $GD $CODEF $EDITOR` — all should be set
3. Check `ss` function works
4. Check `pwdc` works
5. Run `alias | grep edespanso` — should include `espanso restart` on mac
6. Run `gup` from a blog repo — should pull/add/commit/push
