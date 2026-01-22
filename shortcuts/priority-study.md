# Ordem de Interceptação de Teclas no Sistema

## Hierarquia Geral

```
┌─────────────────────────────────────────────┐
│  1. KERNEL / HARDWARE                       │  ← SysRq, Ctrl+Alt+Del (em alguns casos)
├─────────────────────────────────────────────┤
│  2. DISPLAY SERVER (X11 / Wayland / Quartz) │  ← Pode capturar globalmente
├─────────────────────────────────────────────┤
│  3. DESKTOP ENVIRONMENT / WINDOW MANAGER    │  ← Super+Arrows, Alt+Tab, Print Screen
├─────────────────────────────────────────────┤
│  4. APLICAÇÃO (Terminator, Firefox, etc.)   │  ← Ctrl+T, Ctrl+W (se configurado)
├─────────────────────────────────────────────┤
│  5. SHELL / SUBPROCESS (zsh, vim, etc.)     │  ← Ctrl+W, Ctrl+R, Ctrl+C
└─────────────────────────────────────────────┘

        ↓ tecla desce até alguém consumir ↓
```

**Regra:** Quem está **mais acima** e tem o atalho configurado **consome** a tecla. Ela nunca chega às camadas inferiores.

---

## Linux Debian (GNOME + Wayland)

| Camada | Componente | Onde configurar |
|--------|------------|-----------------|
| 1 | Kernel | `/etc/sysctl.conf`, keymaps |
| 2 | Wayland (Mutter) | Integrado ao GNOME |
| 3 | GNOME Shell | `dconf-editor`, Settings |
| 4 | Terminator | `~/.config/terminator/config` |
| 5 | zsh | `~/.zshrc` (bindkey) |

**Exemplo de conflito:**
- GNOME usa `Super+L` para bloquear tela
- Se você tentar usar `Super+L` no Terminator → nunca chega, GNOME consome antes

---

## Linux Arch (pode variar muito)

Arch é mais modular, depende do que você instala:

| Setup | Camada 2-3 | Onde configurar |
|-------|-----------|-----------------|
| GNOME + Wayland | Mutter/GNOME Shell | `dconf-editor` |
| KDE + Wayland | KWin | System Settings → Shortcuts |
| Sway (Wayland) | Sway | `~/.config/sway/config` |
| i3 + X11 | i3wm | `~/.config/i3/config` |
| X11 puro | Nenhum WM forte | `xbindkeys`, `xmodmap` |

**No Arch** você tem mais controle porque escolhe cada componente. Menos conflitos "mágicos", mas mais configuração manual.

---

## macOS

| Camada | Componente | Onde configurar |
|--------|------------|-----------------|
| 1 | Kernel (Darwin) | Raro mexer |
| 2 | Quartz (display) | - |
| 3 | macOS System | System Preferences → Keyboard → Shortcuts |
| 4 | Aplicação | Preferências do app |
| 5 | Shell (zsh) | `~/.zshrc` |

**Particularidades do macOS:**
- `Cmd` é a tecla principal (equivalente ao Super/Win)
- `Ctrl` fica mais "livre" para o terminal
- Muitos atalhos globais são **hardcoded** (Cmd+Q, Cmd+Tab, Cmd+Space)
- Apps podem declarar atalhos no menu, e você pode sobrescrever em System Preferences → Keyboard → App Shortcuts

---

## Quando se preocupar com conflitos?

| Situação | Risco |
|----------|-------|
| Atalho com `Super/Cmd` | **ALTO** — DE/WM geralmente usa |
| Atalho com `Ctrl+Alt` | **MÉDIO** — alguns DEs usam |
| Atalho com `Ctrl` simples | **BAIXO** — geralmente chega ao app/shell |
| Atalho com `Alt` | **MÉDIO** — menus de apps usam Alt |

---

## Ferramentas para debugar conflitos

**No Linux (X11):**
```bash
xev | grep -A2 KeyPress
```

**No Linux (Wayland):**
```bash
wev   # precisa instalar: apt install wev
```

Isso mostra se a tecla está chegando ou sendo consumida antes.

---

## Resumo Comparativo

| Sistema | Mais controle | Mais conflitos "escondidos" |
|---------|---------------|----------------------------|
| Arch (i3/Sway) | ✓✓✓ | Poucos |
| Debian (GNOME) | ✓✓ | Médio (GNOME tem muitos atalhos) |
| macOS | ✓ | Muitos (hardcoded pela Apple) |
