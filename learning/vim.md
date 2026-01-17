# Vim Learning

## Movimento por linhas e palavras
- `h`, `j`, `k`, `l`: Movem o cursor para esquerda, para baixo, para cima e para a direita
- `w`, `e`, `b`: Movem entre palavras (w para a proxima, e para o final da palavra, b para a anterior)

## Movimento por paragrafos
- `{` e `}`: Navegam para o inicio ou fim do bloco atual

## Saltos rapidos
- `0`: Vai para o inicio da linha
- `^`: Vai para o primeiro caractere nao em branco
- `$`: Vai para o final da linha

## Movimentacao basica
| Key | Action |
|-----|--------|
| `h` | Um caracter a esquerda |
| `j` | Uma linha pra baixo |
| `k` | Uma linha pra cima |
| `l` | Um caracter a direita |

## Novas linhas
| Key | Action |
|-----|--------|
| `p` | Nova linha em modo de edicao |
| `o` | Nova linha e inicia modo de insercao |

## Navegacao de pagina
| Key | Action |
|-----|--------|
| `Ctrl+f` | Page down |
| `Ctrl+b` | Page up |
| `Ctrl+d` | Page down de 1/2 pagina |
| `Ctrl+u` | Page up de 1/2 pagina |
| `Ctrl+e` | Uma linha pra baixo |
| `Ctrl+y` | Uma linha pra cima |

## Navegacao no arquivo
| Key | Action |
|-----|--------|
| `gg` | Inicio do arquivo |
| `G` | Final do arquivo |
| `50%` | Meio do arquivo |
| `100%` | Final do arquivo |

## Posicao na janela
| Key | Action |
|-----|--------|
| `H` | Topo da janela |
| `M` | Meio da janela |
| `L` | Final da janela |

## Centralizacao do cursor
| Key | Action |
|-----|--------|
| `zz` | Centraliza o cursor com relacao a tela |
| `zt` | Alinha abaixo |
| `zb` | Alinha acima |

## Delecao especial
| Key | Action |
|-----|--------|
| `di(` | Apaga todo o conteudo dentro do parenteses |
| `cit` | Deleta todo o conteudo dentro de uma tag |
| `cat` | Deleta toda a tag |
| `dt%` | Deleta todo o conteudo ate o sinal de % |

## Comandos uteis
| Key | Action |
|-----|--------|
| `gi` | Retorna para a ultima linha que estava em modo de insercao |
| `#` | Realiza uma busca "para traz" da palavra sobre o cursor |
| `*` | Realiza uma busca "para frente" da palavra sobre o cursor |

## Movimento por palavras
| Key | Action |
|-----|--------|
| `0` | Comeco da linha |
| `$` | Final da linha |
| `e` | Final da palavra |
| `w` | Proxima palavra |
| `b` | Inicio da palavra |
| `(` | Comeco da frase |
| `)` | Final da frase |

## Movimento com contagem
| Key | Action |
|-----|--------|
| `5w` | 5 palavras a direita |
| `5b` | 5 palavras a esquerda |
| `5j` | 5 linhas para baixo |
| `5k` | 5 linhas para cima |

## Navegacao por blocos
| Key | Action |
|-----|--------|
| `{` | Linha em branco acima |
| `}` | Linha em branco abaixo |
| `%` | Move o cursor para o final do bloco (ex: def/end) |

## Buffer
| Command | Action |
|---------|--------|
| `:bd` | Delete file buffer |

---

# EDICAO

## Exemplo de navegacao
```
<i class="fas fa-arrow-right position-relative top-2 px-2"></i>
```
Acima caso queira ir antes do sinal de maior (>) digite `t + >` o cursor ira para o ultimo caracter antes do sinal de maior.

## Modos de insercao
| Key | Action |
|-----|--------|
| `i` | Modo de insercao anterior ao cursor |
| `I` | Entra em modo de insercao no inicio da linha |
| `o` | Abre uma linha uma insercao abaixo do cursor |
| `O` | Abre uma linha uma insercao acima do cursor |
| `a` | Modo de insercao um caracter a frente |
| `A` | Entra em modo de insercao no final da linha |
| `s` | Apaga na posicao do cursor e entra em modo de insercao |
| `S` | Apaga toda a linha e entra em modo de insercao no inicio da linha |
| `C` | Apaga da posicao do cursor ate o final da linha |

## Edicao basica
| Key | Action |
|-----|--------|
| `u` | Refaz a alteracao (undo) |
| `Ctrl+r` | Refaz (redo) |
| `dd` | Apaga uma linha |
| `x` | Apaga um caracter |
| `r` | Trocar um caracter |

## Localizacao
| Key | Action |
|-----|--------|
| `f{char}` | Localiza o sinal de {char} |
| `;` | Localiza o proximo {char} |

## Selecao e delecao
| Key | Action |
|-----|--------|
| `vit` | Seleciona o conteudo dentro de uma TAG |
| `dw` | Deleta uma palavra |
| `daw` | Deleta uma palavra - Melhor opcao para usar com o ponto |
| `d3w` | Deleta 3 palavras |
| `d$` | Deleta da posicao do cursor ate o final da linha |
| `d0` | Deleta da posicao do cursor ate o inicio da linha |
| `d5l` | Deleta 5 letras a direita |
| `d5h` | Deleta 5 letras a esquerda |
| `cw` | Change word (altera palavra) |

## Copiar e colar
| Key | Action |
|-----|--------|
| `y` | Copia uma linha |
| `y5w` | Copiar 5 palavras |
| `p` | Cola na linha de baixo |
| `P` | Cola na linha de cima |
| `^` | Inicio da linha sem os espacos |

## Operadores
| Key | Action |
|-----|--------|
| `c` | Change |
| `d` | Delete |
| `y` | Yank into register |
| `yat` | Copia todo o conteudo de uma tag |
| `g~` | Swap case |
| `gu` | Make lowercase |
| `gU` | Make uppercase |
| `>` | Shift right |
| `<` | Shift left |
| `=` | Autoindent |
| `!` | Filter {motion} lines through an external program |

## Edicao avancada
| Key | Action |
|-----|--------|
| `diw` | Apaga uma palavra e nao apresenta em modo de insercao |
| `caw` | Apaga uma palavra e ja apresenta em modo de insercao para digitar uma nova palavra |
| `dt+space` | Deletar espacos |
| `df+space` | Deletar espacos |
| `va"` | Marca do inicio ate o final das aspas |
| `di"` | Apaga todo o conteudo dentro das aspas |
| `ci"+space` | Apaga todo o conteudo dentro das aspas |
| `di"` | Apaga todo o conteudo dentro das aspas e retorna para o modo de insert |

---

# VISUAL

## Selecao visual
| Key | Action |
|-----|--------|
| `vip` | Marca toda a palavra |
| `vip` | Marca todo o paragrafo |

## Substituir varias palavras
1. `Ctrl+v` = modo de view block
2. Marcar todas que quer trocar
3. Digitar `c` = change
4. Digitar nova palavra depois a tecla `Esc`

**Nota:** Se voce quiser inserir no lugar de `c` digite `i`

## Identacao em varias linhas
1. `Ctrl+v` = modo de view block
2. Marca a primeira letra
3. Com o `j` desco ate a ultima linha
4. `Ctrl+I` - entra no modo de insercao
5. Uso o tab e depois `Esc`

---

# PROCURANDO E SUBSTITUINDO

| Key/Command | Action |
|-------------|--------|
| `?palavra` | Busca para cima |
| `/palavra` | Busca para baixo |
| `Enter` | Marca toda a busca |
| `n` | Navega para baixo na busca encontrada |
| `N` | Navega para cima na busca encontrada |
| `:%s/config/configure/` | Troca todas as palavras config para configure |
| `:nohl` | Desmarca ultima procura |

---

# NAVEGANDO ENTRE ARQUIVOS

| Command | Action |
|---------|--------|
| `:e caminho do arquivo` | Abre arquivo |
| `o` | Abre um arquivo |
| `:sp` | Split nas janelas |
| `:vsp` | Vertical split nas janelas |
| `\p` | NERDTree |
| `Shift+R` | Atualiza o NERDTree |
| `\t` | Navegar entre arquivos e localiza-los |
| `\b` | Arquivos no buffer |

## Rails navigation
| Command | Action |
|---------|--------|
| `:R` | No model navega para o schema |
| `:A` | No model navega para o spec |
| `gf` | No model navega para outro model |

## Outros comandos
| Command | Action |
|---------|--------|
| `:!` | Executa um commando no shell |
| `:CommandFlush` | Reload no novos arquivos |
| `S` | - |
| `Ctrl+x+=` | Retorna `<%=  %>` |
| `:Ack "palavra a ser pesquisada"` | Pesquisa palavra |
| `:Ack "palavra a ser pesquisada$"` | Adiciona o $ no final |
| `>G` | Identacao |
| `:Rmodel` | Navega para model |

---

# PLUGINS

## vim-surround
- `viw` - marca uma palavra dentro de um texto. Posicione o cursor no inicio da palavra e digite viw.
- Para utilizar o vim-surround digite `VS` depois a tag

**Exemplo:** Hello Word! `VS <strong>`

### Substituir uma tag
Posicione o cursor no inicio da tag e digite `cst` - depois a nova tag

**Exemplo:**
```
<strong>Hello Word! </strong>
```
`cst - <div>` - Substituira strong por div

- `dst` - Delete a tag adicionada

---

# INSERT COMMANDS

| Command | Action |
|---------|--------|
| `50i*` | Repete 50x * |
| `25a*-` | Repete 25x *- |
| `Di)` | Deleta todo o conteudo dentro do parenteses |
| `Yi)` | Copiar todo o conteudo dentro do parenteses |
| `va"` | Seleciona todo conteudo dentro das "" |

---

# VIMGREP

| Command | Action |
|---------|--------|
| `:lvimgrep /dicas/gj ~/*/.txt \| ls` | - |
| `:vimgrep /dicas/gj */.txt \| copen` | - |
| `:vimgrep dicas */.txt \| copen` | - |
| `:h lvim` | Ajuda sobre o comando |

## Quickfix
| Command | Action |
|---------|--------|
| `:copen` | Open the quickfix window |
| `:cclose` | Close the quickfix window |
| `:cnext` | Go to the next location |
| `:cprevious` | Go to the previous location |

---

# PLUGIN MANAGEMENT

| Command | Action |
|---------|--------|
| `:PlugClean` | Remove plugins |
| `:PlugInstall` | Install plugins |
| `:PlugUpdate` | Update plugins |

---

# COC (Conquer of Completion)

| Mapping | Action |
|---------|--------|
| `gd` | Go to definition |
| `gy` | Go to type definition |
| `gi` | Go to implementation |
| `gr` | Go to references |
