---
name: deploy-railway
description: Esta skill deve ser usada ao publicar páginas no Railway via git — commit e push automático, criação de pastas por cliente, verificação da URL pública e HTTPS. Acione quando o usuário disser "publicar", "subir o site", "colocar no ar", "deploy", "railway" ou rodar /publicar ou o teste de conexão do /setup, e o config tiver o bloco `railway` preenchido (em vez de `hostgator`).
---

# Deploy no Railway (via git)

Publicar páginas em `[repoPath]/public/[pastaBase]/[slug]/` dentro do repositório conectado ao Railway, via `git push` — o Railway builda e publica sozinho a cada push na branch monitorada. URL pública final: `https://[dominio]/[pastaBase]/[slug]/`.

## Credenciais

Tudo vem de `prospector-config.json` (bloco `railway`): `repoPath` (pasta local do repo, dentro da pasta conectada), `repoUrl` (ex.: `https://github.com/usuario/meu-site.git`), `branch` (padrão `main`), `dominio` (domínio público do Railway, ex.: `meusite.up.railway.app`), `pastaBase` (padrão `clientes`), `githubToken` (Personal Access Token do GitHub com permissão de push no repo). **O token vive SÓ nesse arquivo, no computador do usuário — nunca é digitado no chat, nunca é exibido em nenhuma saída, log ou comando mostrado ao usuário.** Se faltar, oriente o usuário: dashboard → aba Configurações → Conexão Railway → colar o token e salvar (ou editar o arquivo na mão). Nunca pelo chat.

## Método 1 — Push direto do sandbox (tentar primeiro, silencioso)

Diferente de FTP/cPanel, git sobre HTTPS geralmente NÃO é bloqueado pela rede do sandbox. Por isso, tente publicar você mesmo antes de acionar o usuário:

1. Copie/gere os arquivos do cliente em `[repoPath]/public/[pastaBase]/[slug]/index.html` (página) e `.../proposta.html` (capa).
2. Dentro de `[repoPath]`: `git add -A && git commit -m "publica: [slug]"`.
3. `git push https://x-access-token:[token do config]@[host+caminho do repoUrl] HEAD:[branch]` — token lido do arquivo, jamais mostrado ou digitado no chat.
4. Se o push funcionar, ótimo: zero ação do usuário. O Railway detecta o push e builda/publica sozinho (~1-2 min). Se a rede do sandbox bloquear (timeout/refused), faltar `repoPath` local ou o repo não existir na pasta conectada, caia SEM DRAMA para o Método 2 — não insista em tentativas repetidas.

## Método 2 — Publicador local (fallback)

1. **Garanta os arquivos do publicador na pasta conectada** (copie de `references/` desta skill, sobrescrevendo versões antigas), conforme o sistema do usuário — pergunte ou detecte: `publicar-agora.command` (Mac) ou `publicar-agora.bat` (Windows). Em dúvida, copie os dois — cada sistema ignora o do outro.
2. Peça UM duplo clique. O script lê `repoPath`, `repoUrl`, `branch` e `githubToken` de `prospector-config.json`, entra no repo, faz `git add -A && git commit && git push` e avisa quando terminar. Nada fica agendado — é rodar de novo a cada `/publicar` que passar por aqui. (Se o macOS bloquear por segurança: botão direito → Abrir na primeira vez.)
3. Aguarde ~1-2 min (tempo de build do Railway) e verifique.

## Método 3 — Navegador/CLI Railway (último recurso)

Se git também estiver bloqueado na máquina do usuário (sem git instalado): oriente a instalar o Git ou usar a CLI/dashboard do próprio Railway para redeploy manual do commit mais recente — o USUÁRIO faz o login dele (nunca peça token ou senha no chat).

## Verificação (obrigatória, após qualquer método)

1. Abra `https://[dominio]/[pastaBase]/[slug]/` e a capa `.../proposta.html` — confirme que carregam com conteúdo certo. Builds do Railway levam ~1-2 min; se ainda não subiu, aguarde e teste de novo antes de reportar falha.
2. **HTTPS**: o Railway emite certificado automático para domínios `*.up.railway.app` e para domínios próprios já apontados — normalmente não precisa de ação manual. Se der erro de certificado num domínio próprio: confira em Railway → Settings → Domains se o domínio está com status "Active" (pode levar alguns minutos após o CNAME apontar). Enquanto o HTTPS não validar, a publicação NÃO está concluída — link `http://` NUNCA vai para cliente.
3. Atualize `leads.md` + dashboard com status `publicado` e a URL.

## Pré-requisito único (setup, uma vez por projeto)

O serviço Railway precisa servir arquivos estáticos a partir de `public/`. Se o repo ainda não tiver isso: copie `references/servidor-estatico/server.js` e `references/servidor-estatico/package.json` para a raiz do repo, commit e push — o Railway detecta Node automaticamente (via `npm start`) e passa a servir `public/[pastaBase]/[slug]/index.html` no caminho correspondente. Sem dependências externas.

## Teste de conexão do /setup

Publique `teste.html` simples ("Funcionou!") em `[repoPath]/public/[pastaBase]/teste/index.html` pelo Método 1; se bloqueado, copie o `publicar-agora` da pasta conectada e peça o clique — assim o usuário aprende o fluxo logo no setup.
