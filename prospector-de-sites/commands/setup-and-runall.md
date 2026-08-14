---
description: Garante o setup e roda o funil inteiro sozinho — todos os nichos do config, do prospectar até o rascunho de proposta — parando só na hora de você mandar os e-mails
---

Rode o Prospector de Sites de ponta a ponta, sem pausar pra confirmação entre etapas. A ÚNICA etapa manual do fluxo inteiro é revisar e clicar em enviar os rascunhos de e-mail no final — isso o usuário faz sozinho, depois.

**Regra de ouro deste comando: UM preflight só, no início — nunca descubra um requisito faltando no meio do funil.** Se o Gmail não estiver conectado, se a hospedagem não estiver configurada no dashboard, se faltar qualquer coisa — é AGORA, no passo 0, que isso aparece, tudo junto, numa única rodada. Depois do passo 0 fechado, o funil roda sem interromper o usuário de novo até o relatório final.

## 0. Preflight único (tudo de uma vez, antes de processar qualquer lead)

Leia `prospector-config.json` na pasta conectada e trate TODO valor já preenchido como definitivo — nunca re-pergunte o que já está salvo de uma execução anterior (mesma regra do `/setup`: reusar por padrão, só perguntar o que falta ou o que o usuário pedir pra mudar).

Monte uma lista única de pendências verificando, nesta ordem, sem pular nenhuma:

1. **Config básico**: assinatura, nichos padrão, cidade, leads por busca, incluir leads sem site, modo de envio — pendente só se algum estiver vazio.
2. **Hospedagem**: bloco `hostgator` ou `railway` preenchido (o que o usuário já usa). Se nenhum dos dois estiver, é pendência.
3. **Conectores**: Claude in Chrome e conector do Gmail — confira se estão ativos AGORA, não espere `/prospectar` ou `/proposta` descobrirem isso sozinhos no meio do funil.
4. **Dashboard**: `dashboard.html` e `dashboard-server.py` existem na pasta conectada? Se não, é pendência (mas não trava o funil — pode ser criado em paralelo).

- **Se houver qualquer pendência**: resolva TODAS de uma vez, seguindo o comando `/setup` na íntegra (ele já implementa essa mesma lógica de "uma rodada só, reusar valores salvos"). Não faça isso em partes espalhadas pelo funil.
- **Se não faltar nada**: confirme em 1 linha ("config completo, conectores ok — rodando o funil") e siga direto, sem perguntar mais nada ao usuário até o relatório final.

Se mesmo depois do preflight a hospedagem continuar sem configurar (usuário disse que ainda não tem conta/projeto), rode mesmo assim os passos 1 e 2 do funil abaixo (prospectar + redesenhar não dependem de hospedagem) e pare antes de publicar, avisando no relatório final o que falta.

## O funil (repita para CADA nicho em `prospeccao.nichos` do config, na ordem em que aparecem)

Use a cidade padrão do config para todos os nichos; se estiver vazia, pergunte uma vez no início da execução (não repita a pergunta por nicho).

Para cada nicho:

1. **Prospectar** — siga a skill `prospeccao-maps` exatamente como o comando `/prospectar` faz: busca "[nicho] em [cidade]", exclui quem já está em `leads.md`, aplica os critérios de qualificação, salva na planilha do Google + `leads.md` + `dashboard.html`.
2. **Redesenhar** — siga a skill `redesign-premium` exatamente como o comando `/redesenhar` faz, para TODOS os leads com status `novo` que acabaram de entrar neste nicho (sem mínimo de 5 e sem pausar para confirmar a lista com o usuário — isso é automático). Gere página + editor + entrada no `comparar.html` para cada um, cumprindo o checklist bloqueante da skill.
3. **Publicar** — se a hospedagem estiver configurada, siga a skill `deploy-hostgator` ou `deploy-railway` (conforme o config) exatamente como o comando `/publicar` faz, para todos os leads recém-redesenhados deste nicho: página + capa (`proposta.html`), com a verificação HTTPS bloqueante. Se a hospedagem não estiver configurada, pule esta etapa e a próxima para este nicho, registre no relatório final quem ficou pendente de publicação, e continue para o próximo nicho.
4. **Proposta** — siga a skill `proposta-email` exatamente como o comando `/proposta` faz, para todos os leads recém-publicados deste nicho com e-mail OU WhatsApp confirmado (`canalContato`), passando pela checklist anti-spam bloqueante. **Ignore o `envio.modo` do config nesta execução para o canal `email`: crie SEMPRE rascunho, nunca envie direto** — enviar é a etapa manual final, mesmo que o usuário tenha configurado envio automático em outro contexto. Canal `whatsapp` já é sempre preparado-nunca-enviado por definição da skill (nada a ignorar aqui). Para leads sem e-mail e sem WhatsApp, registre no relatório como pendência.

Se qualquer cliente falhar numa etapa (ex.: site bloqueou extração, HTTPS não validou, sem e-mail), não pare o funil inteiro — pule esse cliente, registre o motivo no relatório final, e continue com os demais e com o próximo nicho.

## Relatório final (depois de processar todos os nichos)

Apresente uma tabela única com TODOS os clientes processados na execução: nicho, cliente, status final (`publicado`/`proposta`/pendência), URL da página, URL da capa, e se o rascunho de e-mail foi criado. Separe uma seção "Pendências" para quem parou no meio do caminho (sem hospedagem, sem e-mail, falha de extração etc.) com o motivo de cada uma.

Feche com a orientação: "Os rascunhos de e-mail estão no Gmail e as mensagens de WhatsApp estão prontas nos links/abas abertas — revise e envie quando quiser. Depois de enviar, `/respostas` verifica quem respondeu por e-mail e `/followup` cuida de quem ficar 3+ dias sem resposta; leads de WhatsApp você acompanha e marca manualmente no dashboard."
