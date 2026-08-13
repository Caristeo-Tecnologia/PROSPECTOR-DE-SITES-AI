---
description: Garante o setup e roda o funil inteiro sozinho — todos os nichos do config, do prospectar até o rascunho de proposta — parando só na hora de você mandar os e-mails
---

Rode o Prospector de Sites de ponta a ponta, sem pausar pra confirmação entre etapas. A ÚNICA etapa manual do fluxo inteiro é revisar e clicar em enviar os rascunhos de e-mail no final — isso o usuário faz sozinho, depois.

## 0. Garanta o setup

Leia `prospector-config.json` na pasta conectada.

- **Não existe, ou falta assinatura/prospecção**: execute o fluxo completo do comando `/setup` (mesmos passos e perguntas — assinatura, nichos padrão, cidade, leads por busca, modo de envio) antes de prosseguir. Essa parte é interativa por natureza (dados pessoais e credenciais não têm como ser adivinhados).
- **Falta a hospedagem** (nem `hostgator` nem `railway` preenchidos): siga a seção "4. Conexão com a hospedagem" do `/setup` para configurar uma das duas. Se o usuário disser que ainda não contratou/criou o projeto, rode mesmo assim as etapas 1 e 2 abaixo (prospectar + redesenhar não dependem de hospedagem) e pare antes de publicar, avisando o que falta.
- **Config completo**: siga direto para o funil.

## O funil (repita para CADA nicho em `prospeccao.nichos` do config, na ordem em que aparecem)

Use a cidade padrão do config para todos os nichos; se estiver vazia, pergunte uma vez no início da execução (não repita a pergunta por nicho).

Para cada nicho:

1. **Prospectar** — siga a skill `prospeccao-maps` exatamente como o comando `/prospectar` faz: busca "[nicho] em [cidade]", exclui quem já está em `leads.md`, aplica os critérios de qualificação, salva na planilha do Google + `leads.md` + `dashboard.html`.
2. **Redesenhar** — siga a skill `redesign-premium` exatamente como o comando `/redesenhar` faz, para TODOS os leads com status `novo` que acabaram de entrar neste nicho (sem mínimo de 5 e sem pausar para confirmar a lista com o usuário — isso é automático). Gere página + editor + entrada no `comparar.html` para cada um, cumprindo o checklist bloqueante da skill.
3. **Publicar** — se a hospedagem estiver configurada, siga a skill `deploy-hostgator` ou `deploy-railway` (conforme o config) exatamente como o comando `/publicar` faz, para todos os leads recém-redesenhados deste nicho: página + capa (`proposta.html`), com a verificação HTTPS bloqueante. Se a hospedagem não estiver configurada, pule esta etapa e a próxima para este nicho, registre no relatório final quem ficou pendente de publicação, e continue para o próximo nicho.
4. **Rascunho de proposta** — siga a skill `proposta-email` exatamente como o comando `/proposta` faz, para todos os leads recém-publicados deste nicho com e-mail confirmado, passando pela checklist anti-spam bloqueante. **Ignore o `envio.modo` do config nesta execução: crie SEMPRE rascunho, nunca envie direto** — enviar é a etapa manual final, mesmo que o usuário tenha configurado envio automático em outro contexto. Para leads sem e-mail, registre no relatório que a abordagem fica manual via WhatsApp.

Se qualquer cliente falhar numa etapa (ex.: site bloqueou extração, HTTPS não validou, sem e-mail), não pare o funil inteiro — pule esse cliente, registre o motivo no relatório final, e continue com os demais e com o próximo nicho.

## Relatório final (depois de processar todos os nichos)

Apresente uma tabela única com TODOS os clientes processados na execução: nicho, cliente, status final (`publicado`/`proposta`/pendência), URL da página, URL da capa, e se o rascunho de e-mail foi criado. Separe uma seção "Pendências" para quem parou no meio do caminho (sem hospedagem, sem e-mail, falha de extração etc.) com o motivo de cada uma.

Feche com a orientação: "Os rascunhos estão no Gmail — revise e envie quando quiser. Depois de enviar, `/respostas` verifica quem respondeu e `/followup` cuida de quem ficar 3+ dias sem resposta."
