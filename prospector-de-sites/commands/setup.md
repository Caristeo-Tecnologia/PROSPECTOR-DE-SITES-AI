---
description: Configura o plugin — assinatura, preferências, hospedagem e conectores (roda uma vez; execuções seguintes só perguntam o que mudou)
---

Configure o ambiente do Prospector de Sites. Regra geral: **uma única rodada de perguntas, não uma pergunta por vez.** Levante tudo que falta primeiro (config, hospedagem, conectores), depois pergunte tudo de uma vez (uma chamada de formulário/AskUserQuestion com todos os campos pendentes) — nunca interrompa o usuário várias vezes ao longo do comando por coisas que já podiam ter sido perguntadas juntas.

## 1. Pasta de trabalho

Verifique se há uma pasta do usuário conectada. Se não houver, peça para conectar uma pasta (ex.: "Clientes") usando a ferramenta de solicitação de pasta — tudo (config, leads e sites criados) será salvo nela para persistir entre sessões.

## 2. Levante o que já existe (NUNCA re-pergunte o que já está preenchido)

Procure `prospector-config.json` na pasta conectada.

- **Não existe**: todos os campos abaixo estão pendentes.
- **Existe**: leia TODOS os valores salvos e trate-os como padrão definitivo — assinatura, nichos, cidade, leads por busca, incluir leads sem site, modo de envio, bloco de hospedagem (`hostgator` ou `railway`). Mostre um resumo compacto ao usuário (sem exibir senha/token) e pergunte apenas: "quer manter tudo assim, ou mudar algo específico?" Se ele disser "manter"/"tá bom"/similar, pule direto para a checagem de conectores (passo 4) — não re-passe pelas perguntas do passo 3. Só reabra a pergunta de um campo se ele pedir para mudar aquele campo, ou se o campo estiver vazio/faltando.

O resultado deste passo é uma lista do que falta de fato preencher — é só isso que vai para o passo 3.

## 3. Uma única rodada de perguntas (só para o que falta)

Monte UMA coleta só (formulário/AskUserQuestion) com todos os campos pendentes identificados no passo 2, dentre:

- **Assinatura da proposta**: nome completo, como quer se apresentar (ex.: "Designer de páginas de alta conversão") e WhatsApp/telefone de contato.
- **Nichos padrão de prospecção**: sugira nutricionistas, psicólogos, advogados e psiquiatras como ponto de partida, mas deixe o usuário editar livremente.
- **Cidade/região padrão**.
- **Leads qualificados por busca**: padrão 10.
- **Incluir leads sem site**: pergunta sim/não, padrão **não**. Se sim, a prospecção passa a aceitar também negócios bem avaliados que ainda não têm nenhum site (não só os com site ruim) — o pitch vira "criar o primeiro site" em vez de "redesenhar". Explique em 1 linha antes de perguntar.
- **Modo de envio da proposta**: padrão "criar rascunho no Gmail para revisão" (recomendado). Alternativa: enviar direto. Mencione de passagem (não precisa perguntar, é comportamento fixo): lead sem e-mail usa WhatsApp como canal automaticamente, sempre preparado pra revisão — nunca enviado sozinho.
- **Qual hospedagem**: HostGator (cPanel/FTP) ou Railway (deploy via git) — só se ainda não houver nenhum dos dois blocos preenchido no config.

Se nada estiver pendente (config completo de uma execução anterior), pule este passo inteiro.

## 4. Conexão com a hospedagem

Vale só para o bloco que o usuário escolheu (HostGator OU Railway) — não peça os dois. Se o bloco já estava preenchido no config (passo 2) e o usuário não pediu para mudar, pule para o teste de conexão do passo 6.

### HostGator

- **Se ainda não contratou**: explique brevemente que ele precisa de um plano que aceite múltiplos sites (plano M ou superior), que ao contratar ganha domínio grátis, e que depois de ativar deve voltar e rodar `/setup` de novo. Salve o config parcial e encerre.
- **Se já contratou**: NÃO colete nenhum dado da HostGator pelo chat (nem usuário, nem servidor — e JAMAIS a senha). Tudo vai num lugar só, a aba Configurações do dashboard:
  1. Instrua: abra o dashboard (`iniciar-dashboard.bat` na pasta conectada) → aba **Configurações** → seção **Conexão HostGator**.
  2. Lá ele preenche os 4 campos + senha: usuário, domínio, servidor (os três aparecem na tela inicial do cPanel, coluna "General Information") e a senha do cPanel. Clica em "Salvar conexão" → tudo vai do navegador direto pro `prospector-config.json` no computador dele, sem passar pelo chat.
  3. Peça para ele avisar quando salvar ("salvei") — aí você LÊ o config (verificando que os campos estão preenchidos, sem nunca exibir a senha) e roda o teste de conexão.

  Nunca exiba, imprima ou registre a senha em nenhuma saída. Se ele preferir, editar o `prospector-config.json` na mão também vale.

### Railway

- **Se ainda não tem projeto**: explique que ele precisa de um repositório Git (GitHub) já clonado localmente (com `origin` configurado) conectado a um serviço Railway, com o serviço servindo arquivos estáticos a partir de `public/` (a skill `deploy-railway` tem um servidor mínimo pronto em `references/servidor-estatico/` pra copiar se o projeto ainda não tiver isso).
- **Se já tem**: pergunte se o git desse repo já está logado (SSH ou GitHub CLI) na máquina dele — normalmente já está, se ele clona/faz push por lá manualmente. Tudo na aba Configurações do dashboard:
  1. Instrua: abra o dashboard → aba **Configurações** → seção **Conexão Railway**.
  2. Campos obrigatórios: pasta local do repo (JÁ clonado pelo usuário, com `origin` já configurado — nunca um caminho novo pra criar do zero), branch (padrão `main`), domínio público do Railway, pasta base (padrão `clientes`) — nenhum segredo aqui, é só caminho e texto. URL do repo e GitHub Personal Access Token são **opcionais**: só preencher se ele quiser que o `/publicar` rode pelo servidor sem precisar dar o duplo clique no publicador local. Clica em "Salvar conexão" → vai direto pro `prospector-config.json`, sem passar pelo chat.
  3. Peça para avisar quando salvar — aí você LÊ o config (sem nunca exibir o token, se houver) e roda o teste de conexão.

  Nunca exiba, imprima ou registre o token em nenhuma saída. Editar o `prospector-config.json` na mão também vale. **Nunca rode `git init`/`git clone` para "consertar" um repoPath que não existe** — se `[repoPath]/.git` não existir, o caminho está errado; peça o caminho certo.

## 5. Conectores necessários

Confira AGORA — junto com a hospedagem, não deixe pra descobrir no meio de `/prospectar` ou `/proposta` depois:

- **Claude in Chrome**: necessário para prospecção no Maps e extração de sites. Se não estiver conectado, oriente a conectar (ToolSearch/configuração do Cowork).
- **Conector do Gmail**: necessário para criar os rascunhos de proposta. Se não estiver conectado, oriente a conectar agora.

Trate os dois como parte do checklist de saída deste comando — um `/setup` "concluído" com conector faltando não está de fato concluído; avise explicitamente o que falta conectar.

## 6. Salvar e testar

Salve tudo em `prospector-config.json` na pasta conectada, neste formato:

```json
{
  "assinatura": { "nome": "", "apresentacao": "", "whatsapp": "" },
  "prospeccao": { "nichos": ["nutricionistas", "psicologos", "advogados", "psiquiatras"], "cidade": "", "leadsPorBusca": 10, "incluirSemSite": false },
  "envio": { "modo": "rascunho" },
  "hostgator": { "usuario": "", "dominio": "", "servidor": "", "senha": "", "pastaBase": "clientes" },
  "railway": { "repoPath": "", "repoUrl": "", "branch": "main", "dominio": "", "pastaBase": "clientes", "githubToken": "" }
}
```

Preencha só o bloco (`hostgator` ou `railway`) da hospedagem escolhida — o outro fica vazio. Se estiver rodando de novo com config já existente, regrave só os campos que mudaram — nunca sobrescreva com vazio um campo que já tinha valor e não foi tocado nesta execução. Se os dados de hospedagem foram informados, teste a conexão seguindo a skill correspondente (`deploy-hostgator` ou `deploy-railway`): publique uma página `teste.html` simples e informe a URL pública ao usuário. Se o teste falhar, diagnostique (credenciais, servidor/repo, método de upload) antes de concluir.

## 7. Dashboard inicial

Siga a seção "Setup" da skill `dashboard-leads`: copie `dashboard-server.py` e `iniciar-dashboard.bat` para a raiz da pasta conectada, crie o banco `prospector.db` (schema da skill) e gere o `dashboard.html` do template. Se já existirem (execução anterior), não regere do zero — só confirme que estão atualizados. Explique ao usuário: duplo clique em `iniciar-dashboard.bat` abre o painel completo em http://localhost:8765 com edição/exclusão salvando no banco (requer Python no Windows; sem ele, o dashboard.html abre no modo leitura).

## 8. Entregar o manual e os scripts

Copie da pasta do plugin para a pasta conectada (sobrescrevendo versões antigas): `manual.html` (manual do usuário), o iniciador do dashboard certo (`iniciar-dashboard.bat` ou `.command`) e os arquivos da hospedagem escolhida:

- **HostGator** (skill `deploy-hostgator`, references) — Windows: `publicar-agora.ps1/.bat`, `publicador-oculto.vbs`, `instalar-publicador.bat` · Mac: `publicar-agora.command`, `instalar-publicador.command`. Peça UM duplo clique no instalador do publicador (registra o publicador automático — única vez na vida; o teste de conexão do passo 6 pode usar esse fluxo).
- **Railway** (skill `deploy-railway`, references) — Windows: `publicar-agora.bat` · Mac: `publicar-agora.command`. Não precisa instalar nada: é só o fallback pra quando o push direto do sandbox não passar (o teste de conexão do passo 6 pode pedir o duplo clique se isso acontecer).

Apresente o `manual.html` ao usuário com a frase: "Esse é o seu manual — guarda ele que responde 90% das dúvidas." Se já foi apresentado numa execução anterior e nada mudou, pule.

## 9. Encerrar

Confirme o que foi salvo (e o que foi mantido sem mudança), confirme que os dois conectores do passo 5 estão ok, e explique o ciclo (guiando SEMPRE o próximo passo ao fim de cada comando): `/prospectar` → `/redesenhar` → `/publicar` → `/proposta` (ou `/setup-and-runall` pra rodar tudo de uma vez), com `/editor` opcional para ajustes manuais e o `dashboard.html` como painel de controle de tudo.
