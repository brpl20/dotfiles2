# LazyVim

---

## File Explorer (Neo-tree)

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

## Buffers & Tabs

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

## Navigation (Moving Multiple Lines)

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

## Search & Find

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

## Text Objects (Delete Inside)

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
