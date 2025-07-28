#!/usr/bin/env node

const puppeteer = require('puppeteer');
const fs = require('fs');
const path = require('path');
const os = require('os');

class ClaudeTerminalCLI {
    constructor() {
        this.browser = null;
        this.page = null;
        this.userDataDir = this.getChromeProfilePath();
    }

    getChromeProfilePath() {
        const platform = os.platform();
        let profilePath;

        switch (platform) {
            case 'win32':
                profilePath = path.join(os.homedir(), 'AppData', 'Local', 'Google', 'Chrome', 'User Data');
                break;
            case 'darwin':
                profilePath = path.join(os.homedir(), 'Library', 'Application Support', 'Google', 'Chrome');
                break;
            case 'linux':
                profilePath = path.join(os.homedir(), '.config', 'google-chrome');
                break;
            default:
                throw new Error(`Plataforma não suportada: ${platform}`);
        }

        return profilePath;
    }

    async initBrowser() {
        console.log('🚀 Iniciando Chrome com seu perfil...');

        try {
            this.browser = await puppeteer.launch({
                headless: false, // Mude para true se quiser modo headless
                userDataDir: this.userDataDir,
                args: [
                    '--no-sandbox',
                    '--disable-setuid-sandbox',
                    '--disable-dev-shm-usage',
                    '--disable-accelerated-2d-canvas',
                    '--no-first-run',
                    '--no-zygote',
                    '--disable-gpu'
                ]
            });

            this.page = await this.browser.newPage();
            await this.page.setViewport({ width: 1920, height: 1080 });

            console.log('✅ Chrome inicializado com sucesso!');
        } catch (error) {
            console.error('❌ Erro ao inicializar Chrome:', error.message);
            throw error;
        }
    }

    async goToClaude() {
        console.log('🔄 Navegando para Claude...');

        try {
            await this.page.goto('https://claude.ai', {
                waitUntil: 'networkidle2',
                timeout: 30000
            });

            // Aguarda a página carregar completamente
            await this.page.waitForTimeout(3000);

            // Verifica se precisa fazer login
            const isLoggedIn = await this.checkIfLoggedIn();

            if (!isLoggedIn) {
                console.log('⚠️  Você precisa estar logado no Claude. Faça login manualmente e execute novamente.');
                await this.page.waitForTimeout(10000); // Dá tempo para login manual
            }

            console.log('✅ Página do Claude carregada!');
        } catch (error) {
            console.error('❌ Erro ao navegar para Claude:', error.message);
            throw error;
        }
    }

    async checkIfLoggedIn() {
        try {
            // Verifica se existe o campo de texto para mensagens
            const chatInput = await this.page.$('[contenteditable="true"]');
            return !!chatInput;
        } catch (error) {
            return false;
        }
    }

    async sendMessage(prompt) {
        console.log('💬 Enviando mensagem para Claude...');

        try {
            // Aguarda o campo de input aparecer
            await this.page.waitForSelector('[contenteditable="true"]', { timeout: 10000 });

            // Clica no campo de input
            const inputField = await this.page.$('[contenteditable="true"]');
            await inputField.click();

            // Digite a mensagem
            await this.page.keyboard.type(prompt);

            // Aguarda um pouco antes de enviar
            await this.page.waitForTimeout(1000);

            // Procura e clica no botão de enviar
            const sendButton = await this.page.$('button[aria-label="Send Message"], button:has-text("Send")');
            if (sendButton) {
                await sendButton.click();
            } else {
                // Fallback: usar Enter
                await this.page.keyboard.press('Enter');
            }

            console.log('✅ Mensagem enviada!');

            // Aguarda a resposta começar a aparecer
            await this.waitForResponse();

        } catch (error) {
            console.error('❌ Erro ao enviar mensagem:', error.message);
            throw error;
        }
    }

    async waitForResponse() {
        console.log('⏳ Aguardando resposta do Claude...');

        try {
            // Aguarda indicadores de que Claude está respondendo
            await this.page.waitForTimeout(3000);

            // Aguarda até Claude parar de "digitar"
            let previousLength = 0;
            let stableCount = 0;
            const maxStableChecks = 5;

            while (stableCount < maxStableChecks) {
                await this.page.waitForTimeout(2000);

                // Pega o último elemento de resposta
                const messages = await this.page.$$('[data-testid="conversation-turn"]');
                if (messages.length > 0) {
                    const lastMessage = messages[messages.length - 1];
                    const currentContent = await lastMessage.textContent();
                    const currentLength = currentContent.length;

                    if (currentLength === previousLength) {
                        stableCount++;
                    } else {
                        stableCount = 0;
                        previousLength = currentLength;
                    }
                }
            }

            console.log('✅ Resposta recebida!');

        } catch (error) {
            console.log('⚠️  Timeout aguardando resposta, mas prosseguindo...');
        }
    }

    async getLastResponse() {
        try {
            // Pega todas as mensagens da conversa
            const messages = await this.page.$$('[data-testid="conversation-turn"]');

            if (messages.length === 0) {
                return 'Nenhuma resposta encontrada.';
            }

            // Pega a última mensagem (que deve ser a resposta do Claude)
            const lastMessage = messages[messages.length - 1];
            const responseText = await lastMessage.textContent();

            return responseText;

        } catch (error) {
            console.error('❌ Erro ao obter resposta:', error.message);
            return 'Erro ao obter resposta do Claude.';
        }
    }

    async cleanup() {
        if (this.browser) {
            await this.browser.close();
            console.log('🧹 Browser fechado.');
        }
    }

    async askClaude(prompt) {
        try {
            await this.initBrowser();
            await this.goToClaude();
            await this.sendMessage(prompt);

            const response = await this.getLastResponse();

            console.log('\n' + '='.repeat(80));
            console.log('📝 RESPOSTA DO CLAUDE:');
            console.log('='.repeat(80));
            console.log(response);
            console.log('='.repeat(80) + '\n');

            return response;

        } catch (error) {
            console.error('❌ Erro geral:', error.message);
            throw error;
        } finally {
            await this.cleanup();
        }
    }
}

// Função principal para usar via CLI
async function main() {
    const args = process.argv.slice(2);

    if (args.length === 0) {
        console.log(`
🤖 Claude Terminal CLI

Uso: claud "sua pergunta aqui"

Exemplos:
  claud "como usar termux"
  claud "explique javascript"
  claud "crie um script python para ler arquivos"

Este app usa seu perfil do Chrome para conversar com Claude.
Certifique-se de estar logado no https://claude.ai
        `);
        process.exit(0);
    }

    const prompt = args.join(' ').replace(/^["']|["']$/g, ''); // Remove aspas do início/fim

    if (!prompt.trim()) {
        console.error('❌ Por favor, forneça uma pergunta.');
        process.exit(1);
    }

    console.log(`🎯 Pergunta: "${prompt}"\n`);

    const cli = new ClaudeTerminalCLI();

    try {
        await cli.askClaude(prompt);
    } catch (error) {
        console.error('💥 Falha na execução:', error.message);
        process.exit(1);
    }
}

// Executa se chamado diretamente
if (require.main === module) {
    main().catch(console.error);
}

module.exports = ClaudeTerminalCLI;
