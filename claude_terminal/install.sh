#!/bin/bash

# Script de instalação do Claude Terminal CLI
echo "🚀 Configurando Claude Terminal CLI..."

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Função para imprimir com cores
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCESSO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[AVISO]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERRO]${NC} $1"
}

# Verifica se Node.js está instalado
check_node() {
    print_status "Verificando Node.js..."
    if command -v node >/dev/null 2>&1; then
        NODE_VERSION=$(node --version)
        print_success "Node.js encontrado: $NODE_VERSION"
    else
        print_error "Node.js não encontrado!"
        print_status "Instale Node.js em: https://nodejs.org/"
        exit 1
    fi
}

# Verifica se npm está instalado
check_npm() {
    print_status "Verificando npm..."
    if command -v npm >/dev/null 2>&1; then
        NPM_VERSION=$(npm --version)
        print_success "npm encontrado: $NPM_VERSION"
    else
        print_error "npm não encontrado!"
        exit 1
    fi
}

# Cria diretório do projeto
setup_project() {
    PROJECT_DIR="/Users/brpl/code/dotfiles2/claude_terminal"
    print_status "Criando diretório do projeto em: $PROJECT_DIR"

    if [ -d "$PROJECT_DIR" ]; then
        print_warning "Diretório já existe. Removendo..."
        rm -rf "$PROJECT_DIR"
    fi

    mkdir -p "$PROJECT_DIR"
    cd "$PROJECT_DIR"
    print_success "Diretório criado!"
}

# Instala dependências
install_dependencies() {
    print_status "Instalando dependências..."
    npm install puppeteer

    if [ $? -eq 0 ]; then
        print_success "Dependências instaladas!"
    else
        print_error "Falha ao instalar dependências!"
        exit 1
    fi
}

# Cria o comando global
create_global_command() {
    print_status "Criando comando global 'claud'..."

    # Cria link simbólico no PATH
    SCRIPT_PATH="$PROJECT_DIR/claud.js"

    # Torna o script executável
    chmod +x "$SCRIPT_PATH"

    # Diferentes métodos dependendo do sistema
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        LINK_PATH="/usr/local/bin/claud"
        sudo ln -sf "$SCRIPT_PATH" "$LINK_PATH"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # Linux
        LINK_PATH="$HOME/.local/bin/claud"
        mkdir -p "$HOME/.local/bin"
        ln -sf "$SCRIPT_PATH" "$LINK_PATH"

        # Adiciona ao PATH se não estiver
        if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
            echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
            echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc 2>/dev/null || true
            print_warning "Adicionado $HOME/.local/bin ao PATH. Reinicie o terminal ou execute: source ~/.bashrc"
        fi
    else
        # Windows/WSL
        LINK_PATH="/usr/local/bin/claud"
        sudo ln -sf "$SCRIPT_PATH" "$LINK_PATH" 2>/dev/null || {
            print_warning "Não foi possível criar link global. Use: node $SCRIPT_PATH"
        }
    fi

    print_success "Comando 'claud' configurado!"
}

# Testa a instalação
test_installation() {
    print_status "Testando instalação..."

    if command -v claud >/dev/null 2>&1; then
        print_success "Comando 'claud' está disponível!"
        print_status "Teste executando: claud \"olá\""
    else
        print_warning "Comando global não disponível. Use: node $PROJECT_DIR/claud.js"
    fi
}

# Mostra instruções finais
show_instructions() {
    echo ""
    echo "🎉 Instalação concluída!"
    echo ""
    echo "📋 Como usar:"
    echo "   claud \"sua pergunta aqui\""
    echo ""
    echo "📝 Exemplos:"
    echo "   claud \"como usar termux\""
    echo "   claud \"explique javascript\""
    echo "   claud \"crie um script python\""
    echo ""
    echo "⚠️  Importante:"
    echo "   - Certifique-se de estar logado em https://claude.ai no Chrome"
    echo "   - Na primeira execução, o Chrome pode abrir para verificação"
    echo "   - Use aspas para perguntas com espaços"
    echo ""
    echo "📂 Arquivos instalados em: $PROJECT_DIR"
    echo ""
}

# Execução principal
main() {
    echo "🤖 Claude Terminal CLI - Instalador"
    echo "=================================="

    check_node
    check_npm
    setup_project

    # Copia os arquivos do projeto (assumindo que estão no diretório atual)
    if [ -f "claud.js" ]; then
        cp claud.js "$PROJECT_DIR/"
    fi

    if [ -f "package.json" ]; then
        cp package.json "$PROJECT_DIR/"
    fi

    cd "$PROJECT_DIR"

    install_dependencies
    create_global_command
    test_installation
    show_instructions
}

# Executa o script
main "$@"
