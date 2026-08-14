---
name: proposta-email
description: Esta skill deve ser usada ao escrever e enviar a proposta comercial para um lead prospectado — por e-mail (padrão) ou WhatsApp (quando o lead não tem e-mail) — apresentação da nova versão do site (ou do primeiro site, se o lead não tinha nenhum), com rapport e sem preço. Acione quando o usuário disser "enviar proposta", "e-mail para o cliente", "mandar o site para o cliente" ou rodar /proposta ou /followup.
---

# Proposta por e-mail (ou WhatsApp, sem e-mail)

O e-mail NÃO vende — ele desperta curiosidade e prova trabalho feito. O fechamento (preço, escopo, reunião) acontece na resposta. Um e-mail que parece de vendedor morre no spam; um e-mail que parece de uma pessoa que já trabalhou de graça pro destinatário é aberto e respondido. Os mesmos princípios valem pra versão WhatsApp (canal de fallback quando o lead não tem e-mail) — só a forma muda, ver "Canal" abaixo.

## Canal: e-mail ou WhatsApp

Decidido na prospecção (`canalContato` em `leads.md`): `email` é o canal padrão; `whatsapp` é o fallback quando o lead não tinha e-mail público.

- **`email`**: siga a skill inteira como está — assunto, corpo HTML, `create_draft` do Gmail.
- **`whatsapp`**: mesmos princípios (rapport, 1 defeito objetivo sem ofensa, 1 link só, zero preço, zero pressão), mas formato de mensagem curta — 4 a 6 linhas corridas, sem "assunto", tom de mensagem pessoal mesmo (não corta em parágrafos formais). Estrutura: elogio específico → 1 linha sobre o site atual (ou sobre não ter site, ver "Sem site" abaixo) → "preparei uma versão nova, já no ar" + o link da capa → pergunta simples ("dá uma olhada e me conta o que achou?"). **Nunca envie automaticamente**: monte o link `https://wa.me/55DDDNUMERO?text=[mensagem com encodeURIComponent]` e abra-o via Claude in Chrome (ou apresente o link pronto) — a mensagem fica digitada na caixa de texto do WhatsApp Web, esperando o usuário clicar em enviar. Mesmo princípio do rascunho de e-mail: pronta pra revisão, envio é manual.

### Sem site (lead veio de `incluirSemSite`)

O defeito do parágrafo 2 não existe (não há site pra criticar) — troque por uma observação de oportunidade: "vi que a [negócio] ainda não tem um site, e hoje boa parte de quem pesquisa antes de decidir acaba indo pro concorrente que aparece no Google". Mesmo tom, mesma ausência de pressão — é constatação, não cobrança.

## Princípios

1. **Rapport primeiro.** Abrir com elogio ESPECÍFICO e verificável: a nota no Google, uma avaliação real citada, uma credencial do site. Nunca elogio genérico.
2. **A dor sem ofensa.** Apontar 1-2 defeitos objetivos do site atual como oportunidade ("notei que no celular o site fica difícil de ler"), nunca como crítica ao profissional.
3. **A prova antes do pedido.** O trabalho JÁ está feito e no ar. O link é a proposta.
4. **Zero preço.** Preço só na conversa que a resposta abre.
5. **Zero pressão.** Sem urgência falsa, sem "últimas vagas". Um único CTA: dar uma olhada e responder o que achou.
6. **Curto.** 120-180 palavras. Profissional ocupado não lê e-mail longo de desconhecido.

## Estrutura

- **Assunto**: pergunta pessoal e específica, ≤ 60 caracteres, sem cara de marketing. Ex.: `Dra. [Nome], posso te mostrar uma coisa sobre seu site?` ou `Preparei algo para a [Clínica X]`.
- **Parágrafo 1**: quem encontrou + elogio específico (avaliações/credencial).
- **Parágrafo 2**: observação sobre o site atual (1-2 pontos objetivos).
- **Parágrafo 3**: "preparei uma nova versão, já no ar" + O ÚNICO LINK do e-mail: a página-capa (`.../proposta.html`), que mostra antes e depois lado a lado. Se a capa não existir, linkar a página nova direto.
- **Parágrafo 4**: CTA — abrir no celular também, responder com a impressão.
- **Assinatura**: nome, apresentação e WhatsApp do config (assinatura completa humaniza e reduz suspeita).

## Checklist anti-spam (BLOQUEANTE — rodar antes de criar o rascunho)

Revise o e-mail pronto contra CADA item; se falhar em qualquer um, reescreva antes de criar o rascunho:

- [ ] **1 link só** (a página-capa). Dois links no máximo se incluir o site antigo — nunca mais que isso.
- [ ] **Sem encurtador de URL** (bit.ly e afins = spam na certa). O link é o domínio real, com `https://`.
- [ ] **Link como âncora HTML com texto visível limpo.** O Gmail embrulha TODO link em um redirect próprio (`google.com/url?q=...`) ao salvar — não dá pra impedir, e em corpo de texto puro o embrulho fica VISÍVEL, o que parece golpe. Por isso o rascunho é criado com corpo HTML e o link como âncora: `<a href="https://[dominio]/[pastaBase]/[slug]/proposta.html">https://[dominio]/[pastaBase]/[slug]/proposta.html</a>` — texto visível = a URL limpa montada a partir do config (nunca copiada de outro e-mail). O redirect do Google fica só no href invisível, como em qualquer e-mail do Gmail. Depois de criar, confira o rascunho: o texto visível deve começar em `https://[dominio do config]`.
- [ ] **Domínio limpo e humano.** Se o domínio do config for um subdomínio técnico/temporário (cheio de números, tipo `nome1783367206076.1711244.meusitehostgator.com.br`), PARE antes de enviar qualquer proposta: link assim parece golpe e mata a confiança que a capa constrói. Oriente o usuário a ativar o domínio próprio (grátis no plano da HostGator: cPanel → Domains, ou registro em registro.br) e atualizar o campo `dominio` nas Configurações do dashboard. Proposta só sai com domínio apresentável.
- [ ] **Sem palavras-gatilho**: grátis, promoção, imperdível, oferta, desconto, clique aqui, 100%, garantido, urgente.
- [ ] **Sem CAIXA ALTA no assunto, sem "!!", sem emoji** no assunto.
- [ ] **Texto simples** — corpo HTML minimalista (só parágrafos e a âncora do link; zero cores, botões, imagens ou anexos) (anexo de desconhecido aumenta score de spam E medo de abrir; a capa no link substitui o preview).
- [ ] **Assunto ≤ 60 caracteres**, formulado como pergunta ou frase pessoal com o nome do negócio.
- [ ] **Primeira linha 100% personalizada** (nome + fato real das avaliações) — filtros de spam e humanos reconhecem template genérico.
- [ ] **Remetente = conta Gmail pessoal ativa do usuário** (já tem SPF/DKIM do Google). Nunca sugerir disparo em massa: os envios são 1 a 1, poucos por dia — padrão humano.

## Envio

- Canal `email`, modo **rascunho** (padrão): criar via conector do Gmail (`create_draft`) com destinatário, assunto e corpo prontos. Avisar o usuário para revisar antes de enviar.
- Canal `email`, modo **enviar direto**: se o conector não suportar envio, abrir o Gmail web via Claude in Chrome, ou criar o rascunho e avisar.
- Canal `whatsapp`: sempre modo rascunho/preparado (independente do `envio.modo` do config) — ver seção "Canal" acima. Enviar WhatsApp automaticamente não é uma opção desta skill.
- Nunca criar proposta (nenhum canal) para lead sem e-mail E sem WhatsApp confirmados — esse lead nem deveria ter passado da prospecção.

## Página-capa (o que o cliente vê ao clicar)

O link do e-mail leva à página-capa gerada no `/publicar` (template em `references/capa-proposta-template.html`): nome do cliente no topo, antes/depois lado a lado e a assinatura do usuário. Ela existe para dar credibilidade ao clique — o cliente vê o próprio negócio, não um link estranho. Exigências: servida em `https://`, personalizada com dados reais, sem pedido de dado pessoal nenhum.

## Depois do envio

Registrar no banco/`leads.md` (status + data) e no dashboard. As respostas de canal `email` são verificadas pelo comando `/respostas` (Gmail via conector) — sugira ao usuário agendar a verificação diária. Canal `whatsapp` não tem verificação automática (a skill não lê o WhatsApp do usuário) — quem acompanha a resposta é o próprio usuário, direto no WhatsApp; ele marca manualmente no dashboard quando o lead responder. Follow-up pelo `/followup` após 3+ dias úteis sem resposta, só pra canal `email` (1 único follow-up por lead: curto, gentil, "conseguiu ver a página?").
