---
description: Configura o plugin — assinatura, preferências e conexão com a HostGator (roda uma vez)
---

Configure o ambiente do Prospector de Sites. Siga esta ordem:

## 1. Pasta de trabalho

Verifique se há uma pasta do usuário conectada. Se não houver, peça para conectar uma pasta (ex.: "Clientes") usando a ferramenta de solicitação de pasta — tudo (config, leads e sites criados) será salvo nela para persistir entre sessões.

## 2. Verificar config existente

Procure `prospector-config.json` na pasta conectada. Se existir, mostre um resumo (sem exibir a senha) e pergunte o que o usuário quer atualizar. Se não existir, colete os dados abaixo.

## 3. Dados do usuário (perguntar via AskUserQuestion / formulário)

Colete:

- **Assinatura da proposta**: nome completo, como quer se apresentar (ex.: "Designer de páginas de alta conversão") e WhatsApp/telefone de contato.
- **Nichos padrão de prospecção**: sugira nutricionistas, psicólogos, advogados e psiquiatras como ponto de partida, mas deixe o usuário editar livremente.
- **Cidade/região padrão**.
- **Leads qualificados por busca**: padrão 10.
- **Modo de envio da proposta**: padrão "criar rascunho no Gmail para revisão" (recomendado). Alternativa: enviar direto.

## 4. Conexão com a hospedagem

Pergunte qual hospedagem o usuário já tem: **HostGator** (cPanel/FTP) ou **Railway** (deploy via git). Um dos dois — não peça os dois blocos.

### HostGator

- **Se ainda não contratou**: explique brevemente que ele precisa de um plano que aceite múltiplos sites (plano M ou superior), que ao contratar ganha domínio grátis, e que depois de ativar deve voltar e rodar `/setup` de novo. Salve o config parcial e encerre.
- **Se já contratou**: NÃO colete nenhum dado da HostGator pelo chat (nem usuário, nem servidor — e JAMAIS a senha). Tudo vai num lugar só, a aba Configurações do dashboard:
  1. Instrua: abra o dashboard (`iniciar-dashboard.bat` na pasta conectada) → aba **Configurações** → seção **Conexão HostGator**.
  2. Lá ele preenche os 4 campos + senha: usuário, domínio, servidor (os três aparecem na tela inicial do cPanel, coluna "General Information") e a senha do cPanel. Clica em "Salvar conexão" → tudo vai do navegador direto pro `prospector-config.json` no computador dele, sem passar pelo chat.
  3. Peça para ele avisar quando salvar ("salvei") — aí você LÊ o config (verificando que os campos estão preenchidos, sem nunca exibir a senha) e roda o teste de conexão.

  Nunca exiba, imprima ou registre a senha em nenhuma saída. Se ele preferir, editar o `prospector-config.json` na mão também vale.

### Railway

- **Se ainda não tem projeto**: explique que ele precisa de um repositório Git (GitHub) conectado a um serviço Railway, com o serviço servindo arquivos estáticos a partir de `public/` (a skill `deploy-railway` tem um servidor mínimo pronto em `references/servidor-estatico/` pra copiar se o projeto ainda não tiver isso).
- **Se já tem**: pergunte se o git desse repo já está logado (SSH ou GitHub CLI) na máquina dele — normalmente já está, se ele clona/faz push por lá manualmente. Tudo na aba Configurações do dashboard:
  1. Instrua: abra o dashboard → aba **Configurações** → seção **Conexão Railway**.
  2. Campos obrigatórios: pasta local do repo (clonado dentro da pasta conectada, com `origin` já configurado), branch (padrão `main`), domínio público do Railway, pasta base (padrão `clientes`) — nenhum segredo aqui, é só caminho e texto. URL do repo e GitHub Personal Access Token são **opcionais**: só preencher se ele quiser que o `/publicar` rode pelo servidor sem precisar dar o duplo clique no publicador local. Clica em "Salvar conexão" → vai direto pro `prospector-config.json`, sem passar pelo chat.
  3. Peça para avisar quando salvar — aí você LÊ o config (sem nunca exibir o token, se houver) e roda o teste de conexão.

  Nunca exiba, imprima ou registre o token em nenhuma saída. Editar o `prospector-config.json` na mão também vale.

## 5. Salvar e testar

Salve tudo em `prospector-config.json` na pasta conectada, neste formato:

```json
{
  "assinatura": { "nome": "", "apresentacao": "", "whatsapp": "" },
  "prospeccao": { "nichos": ["nutricionistas", "psicologos", "advogados", "psiquiatras"], "cidade": "", "leadsPorBusca": 10 },
  "envio": { "modo": "rascunho" },
  "hostgator": { "usuario": "", "dominio": "", "servidor": "", "senha": "", "pastaBase": "clientes" },
  "railway": { "repoPath": "", "repoUrl": "", "branch": "main", "dominio": "", "pastaBase": "clientes", "githubToken": "" }
}
```

Preencha só o bloco (`hostgator` ou `railway`) da hospedagem escolhida — o outro fica vazio. Se os dados foram informados, teste a conexão seguindo a skill correspondente (`deploy-hostgator` ou `deploy-railway`): publique uma página `teste.html` simples e informe a URL pública ao usuário. Se o teste falhar, diagnostique (credenciais, servidor/repo, método de upload) antes de concluir.

## 6. Dashboard inicial

Siga a seção "Setup" da skill `dashboard-leads`: copie `dashboard-server.py` e `iniciar-dashboard.bat` para a raiz da pasta conectada, crie o banco `prospector.db` (schema da skill) e gere o `dashboard.html` do template. Explique ao usuário: duplo clique em `iniciar-dashboard.bat` abre o painel completo em http://localhost:8765 com edição/exclusão salvando no banco (requer Python no Windows; sem ele, o dashboard.html abre no modo leitura).

## 7B. Entregar o manual e os scripts

Copie da pasta do plugin para a pasta conectada (sobrescrevendo versões antigas): `manual.html` (manual do usuário), o iniciador do dashboard certo (`iniciar-dashboard.bat` ou `.command`) e os arquivos da hospedagem escolhida:

- **HostGator** (skill `deploy-hostgator`, references) — Windows: `publicar-agora.ps1/.bat`, `publicador-oculto.vbs`, `instalar-publicador.bat` · Mac: `publicar-agora.command`, `instalar-publicador.command`. Peça UM duplo clique no instalador do publicador (registra o publicador automático — única vez na vida; o teste de conexão do item 5 pode usar esse fluxo).
- **Railway** (skill `deploy-railway`, references) — Windows: `publicar-agora.bat` · Mac: `publicar-agora.command`. Não precisa instalar nada: é só o fallback pra quando o push direto do sandbox não passar (o teste de conexão do item 5 pode pedir o duplo clique se isso acontecer).

Apresente o `manual.html` ao usuário com a frase: "Esse é o seu manual — guarda ele que responde 90% das dúvidas."

## 7. Encerrar

Confirme o que foi salvo e explique o ciclo (guiando SEMPRE o próximo passo ao fim de cada comando): `/prospectar` → `/redesenhar` → `/publicar` → `/proposta`, com `/editor` opcional para ajustes manuais e o `dashboard.html` como painel de controle de tudo.
