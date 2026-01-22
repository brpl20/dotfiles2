# Atalhos do Shell (Bash/Zsh)

Esses atalhos são controlados pelo **shell** (via readline no bash, ou built-in no zsh), não pelo terminal emulator.

## Arquivos de Configuração

| Shell | Arquivo de config | Comando para configurar |
|-------|-------------------|------------------------|
| bash | `~/.inputrc` | `bind` |
| zsh | `~/.zshrc` | `bindkey` |

---

## Atalhos de Navegação

| Atalho | Ação |
|--------|------|
| `Ctrl+A` | Ir para o **início** da linha |
| `Ctrl+E` | Ir para o **fim** da linha |
| `Ctrl+B` | Mover um caractere para **trás** |
| `Ctrl+F` | Mover um caractere para **frente** |
| `Alt+B` | Mover uma **palavra** para trás |
| `Alt+F` | Mover uma **palavra** para frente |

---

## Atalhos de Edição

| Atalho | Ação |
|--------|------|
| `Ctrl+W` | Apagar **palavra anterior** |
| `Ctrl+U` | Apagar do cursor até o **início** da linha |
| `Ctrl+K` | Apagar do cursor até o **fim** da linha |
| `Ctrl+Y` | Colar (yank) texto apagado |
| `Ctrl+D` | Apagar caractere sob o cursor (ou sair se linha vazia) |
| `Ctrl+H` | Apagar caractere anterior (backspace) |
| `Ctrl+T` | Trocar dois caracteres de posição |
| `Alt+T` | Trocar duas palavras de posição |
| `Alt+U` | Converter palavra para MAIÚSCULAS |
| `Alt+L` | Converter palavra para minúsculas |
| `Alt+C` | Capitalizar palavra |

---

## Atalhos de Histórico

| Atalho | Ação |
|--------|------|
| `Ctrl+R` | Busca reversa no histórico |
| `Ctrl+S` | Busca para frente no histórico |
| `Ctrl+P` | Comando anterior (igual seta para cima) |
| `Ctrl+N` | Próximo comando (igual seta para baixo) |
| `Ctrl+G` | Cancelar busca no histórico |
| `Alt+.` | Inserir último argumento do comando anterior |

---

## Atalhos de Controle

| Atalho | Ação |
|--------|------|
| `Ctrl+C` | Cancelar comando atual (SIGINT) |
| `Ctrl+Z` | Suspender processo (SIGTSTP) |
| `Ctrl+D` | EOF / Sair do shell (se linha vazia) |
| `Ctrl+L` | Limpar tela |
| `Ctrl+S` | Pausar output (flow control) |
| `Ctrl+Q` | Retomar output (flow control) |

---

## Ver Todos os Atalhos

**Bash:**
```bash
bind -P | grep -v "not bound"
```

**Zsh:**
```bash
bindkey
```

---

## Reconfigurar Atalhos

**Bash (~/.inputrc):**
```bash
# Exemplo: Ctrl+W apaga linha inteira
"\C-w": kill-whole-line
```

**Zsh (~/.zshrc):**
```bash
# Exemplo: Ctrl+W apaga linha inteira
bindkey '^W' kill-whole-line

# Alt+Backspace apaga palavra
bindkey '^[^?' backward-kill-word
```

---

## Notação de Teclas

| Notação | Significado |
|---------|-------------|
| `^X` | Ctrl+X |
| `\C-x` | Ctrl+X (readline) |
| `\e` ou `^[` | Escape / Alt |
| `\M-x` | Alt+X (Meta) |
