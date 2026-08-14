---
name: prospeccao-maps
description: Esta skill deve ser usada ao prospectar clientes no Google Maps — buscar negócios bem avaliados com sites ruins, qualificar leads, avaliar qualidade de sites de terceiros e montar a planilha de leads. Acione quando o usuário disser "prospectar", "buscar clientes", "achar leads", "clientes com site ruim" ou rodar /prospectar.
---

# Prospecção no Google Maps

Encontrar o cliente ouro: negócio que JÁ fatura bem (nota alta, muitas avaliações) mas perde clientes por causa de um site fraco. Não se cria demanda — conserta-se onde o dinheiro está escapando.

## Fluxo (via Claude in Chrome)

1. Abrir `https://www.google.com/maps` e buscar `[nicho] em [cidade]`.
2. Percorrer os resultados um a um, em ordem. Para cada estabelecimento:
   - Abrir o perfil e ler nota, nº de avaliações e link do site.
   - **Filtro 1 — potencial financeiro**: nota ≥ 4.7 E avaliações ≥ 40. Reprovou → próximo. Vale igual pra quem tem site e pra quem não tem — a tese é sempre "negócio que já fatura bem", nunca "vamos criar demanda do zero".
   - **Filtro 2 — site**: depende de `prospeccao.incluirSemSite` no config.
     - Lead **tem site**: segue pro Filtro 3 normalmente.
     - Lead **sem site** (ou "site" que é só diretório de terceiros/linktree, ou fora do ar): se `incluirSemSite` for `false` (padrão) → descartar (registrar o motivo) e seguir. Se for `true` → candidato direto, sem passar pelo Filtro 3 (não há site pra julgar) — é o lead mais forte que existe: zero atrito com decisão já tomada, a oferta vira "seu primeiro site profissional" em vez de "uma versão melhor do site atual". Motivo a registrar: `sem site próprio`.
   - **Filtro 3 — site ruim** (só se aplica a quem tem site): abrir o site em nova aba e avaliar pelos critérios abaixo. Site bom → descartar. Site ativo porém ruim → candidato (falta só o contato).
3. Parar ao atingir a meta de leads qualificados (config, padrão 10) ou após avaliar 25 estabelecimentos.
4. Pular estabelecimentos que já estão em `leads.md` (avaliados em buscas anteriores).

## Critérios de site ruim (guardar o motivo específico)

Qualifica como lead se o site (ativo) tiver 2 ou mais destes problemas:

- Layout datado (aparência de template de 10+ anos, fontes de sistema, imagens esticadas/pixeladas)
- Sem CTA claro de agendamento/contato (nenhum botão de WhatsApp ou agenda visível na primeira dobra)
- Domínio gratuito ou hospedado em plataforma alheia (Google Sites, Wix grátis, subdomínio de terceiros com marca da plataforma)
- Não responsivo (quebra no mobile)
- Conteúdo desorganizado: serviços escondidos, sem hierarquia, texto corrido sem seções
- Sem prova social (nenhuma avaliação/depoimento, apesar da nota alta no Google)

O motivo anotado deve ser objetivo e verificável — ele será citado na proposta. Ex.: "domínio redireciona para Google Sites gratuito, template básico, sem CTA de agendamento".

## Coleta por lead

Nome, nota, nº de avaliações, telefone, WhatsApp, e-mail, URL do site (se houver), motivo.

**Lead sem site (`incluirSemSite` ligado): a fonte de conteúdo é o perfil do Google Maps/Google Business**, não um site — colete tudo que der direto do perfil: categoria, descrição, fotos da galeria (role até o fim pra pegar todas), horário de funcionamento, endereço, avaliações em destaque. É o que o `/redesenhar` vai usar depois em vez de extrair de um HTML antigo.

**WHATSAPP: capture SEMPRE, separado do telefone.** Fontes, na ordem: botão/link de WhatsApp no site do lead, se houver (procure `wa.me/`, `api.whatsapp.com` ou ícone de WhatsApp — extraia o número do link); telefone celular do perfil do Maps (números com 9º dígito são celular no Brasil — assuma WhatsApp). Registre no formato internacional `55 + DDD + número` (ex.: `5511999990000`), pronto pra `wa.me`.

**E-MAIL OU WHATSAPP — pelo menos um é obrigatório.** A proposta precisa de um canal pra chegar no lead: e-mail é o canal principal (mais profissional, menos intrusivo), WhatsApp é o canal de fallback quando não há e-mail. Procure o e-mail nesta ordem: site (rodapé e página de contato), links `mailto:`, home do site da clínica onde atende, busca no Google por "[nome] + email/contato". Se NÃO encontrar e-mail, **não descarte automaticamente**: o lead qualifica mesmo assim se o WhatsApp coletado acima for utilizável — registre `canalContato: whatsapp` (em vez de `email`) e siga; a proposta vai por lá (skill `proposta-email`, seção de canal WhatsApp). Só descarte de fato quando faltarem OS DOIS (nem e-mail nem WhatsApp) — registre na lista de descartados o contato que existir (ex. Instagram) e continue buscando o próximo até bater a meta. Atenção: "site" que aponta para diretório de terceiros (localtreino, acheioprofissional etc.) não conta como site próprio — trata como sem site no Filtro 2.

## Saída — Google Sheets + leads.md local

Destino principal: PLANILHA DO GOOGLE (via conector do Google Drive: `create_file` com CSV em `textContent` e `contentMimeType: text/csv` — converte automaticamente para Sheets). Título `Leads Prospector — [nicho] [cidade]`; incluir qualificados e descartados, ranqueados por potencial (nota alta + site pior). Entregar o link ao usuário.

Cópia de trabalho local `leads.md` (mesmas colunas) para controle de status, já que o conector do Drive não edita células:

```markdown
| # | Nome | Nota | Aval. | E-mail | WhatsApp | Canal | Telefone | Site atual | Motivo | Status | URL nova |
```

`Canal` = `email` ou `whatsapp` (qual dos dois vai ser usado na proposta, decidido na coleta acima). `Site atual` = URL do site ou `sem site` para os candidatos captados via `incluirSemSite`.

Status possíveis: `novo`, `redesenhado`, `publicado`, `proposta enviada`. Quando um status mudar (redesenhar/publicar/proposta), regenerar a planilha do Google com os dados acumulados e atualizar o `dashboard.html` (skill `dashboard-leads`). Nunca sobrescrever leads antigos — apenas acrescentar e atualizar.

## Boas práticas

- Trabalhar por região dá vantagem: menos concorrência na oferta e conhecimento local.
- Enquanto o navegador trabalha, não interromper o fluxo com perguntas — só reportar a tabela final.
- Se o Google Maps pedir login/captcha, pausar e avisar o usuário.
