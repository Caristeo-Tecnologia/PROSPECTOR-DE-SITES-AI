---
description: Escreve e envia (ou cria rascunho) da proposta por e-mail via Gmail
argument-hint: "[nome do cliente ou todos]"
---

Envie propostas para os leads com página publicada, seguindo a skill `proposta-email`.

## Passos

1. Leia `prospector-config.json` (assinatura e modo de envio) e `leads.md`.
2. Determine os destinatários: `$ARGUMENTS`, ou todos os leads com status `publicado` que ainda não receberam proposta. Precisa de e-mail OU WhatsApp confirmado (campo `canalContato` do lead) — sem os dois, não há como propor, deixe de fora e avise.
3. Para cada cliente, escreva a mensagem seguindo a skill `proposta-email` na íntegra pro canal daquele lead (`email` ou `whatsapp`), usando os dados reais: elogio baseado nas avaliações do Google, o defeito específico apontado na prospecção (ou a observação de oportunidade, se o lead não tinha site) e — como ÚNICO link — a página-capa publicada (`https://[dominio]/[pastaBase]/[slug]/proposta.html`). Se a capa não foi publicada, gere e publique-a agora (template na skill `proposta-email`, upload pela skill de deploy configurada) antes de criar a proposta. NUNCA mencione preço.
4. **Checklist anti-spam (bloqueante)**: valide a mensagem contra a checklist da skill `proposta-email` (1 link, sem palavras-gatilho, sem anexo, primeira linha personalizada; pro canal `email` vale também assunto-pergunta ≤ 60 caracteres). Reescreva até passar em todos os itens.
5. Envio conforme o canal:
   - **`email`**, modo do config:
     - **rascunho** (padrão): crie o rascunho pelo conector do Gmail e informe que está pronto para revisão na caixa de rascunhos.
     - **enviar direto**: se o conector do Gmail não oferecer envio direto, use o Claude in Chrome no Gmail web para enviar, ou crie o rascunho e avise o usuário.
   - **`whatsapp`**: SEMPRE preparado, nunca enviado automaticamente (ignora o modo do config) — monte o link `wa.me` com a mensagem pronta e abra-o (Claude in Chrome) ou apresente o link ao usuário; a mensagem fica na caixa de texto esperando o clique manual em enviar.
6. Atualize `leads.md` e o banco do dashboard: status `proposta` + data de envio + canal usado.

## Saída

Resuma: quantas propostas criadas por canal (rascunhos de e-mail vs mensagens de WhatsApp prontas) e para quem, com o link da capa de cada uma. Lembre o usuário: `/respostas` verifica quem respondeu por e-mail (dá pra agendar diário) e `/followup` cuida de quem está 3+ dias sem responder — leads de WhatsApp o próprio usuário acompanha e marca manualmente no dashboard.
