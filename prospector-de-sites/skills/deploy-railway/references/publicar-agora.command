#!/bin/bash
# Prospector de Sites — publica no Railway via git push (Mac).
cd "$(dirname "$0")"
CFG=prospector-config.json
[ -f "$CFG" ] || { echo "ERRO: prospector-config.json nao encontrado."; read -p "Pressione Enter para fechar..."; exit 1; }
REPO=$(python3 -c "import json;print(json.load(open('$CFG'))['railway'].get('repoPath',''))" 2>/dev/null)
URL=$(python3 -c "import json;print(json.load(open('$CFG'))['railway'].get('repoUrl',''))" 2>/dev/null)
BRANCH=$(python3 -c "import json;print(json.load(open('$CFG'))['railway'].get('branch') or 'main')" 2>/dev/null)
TOKEN=$(python3 -c "import json;print(json.load(open('$CFG'))['railway'].get('githubToken',''))" 2>/dev/null)
[ -n "$REPO" ] && [ -d "$REPO" ] || { echo "ERRO: repoPath do Railway nao configurado ou pasta inexistente. Preencha no dashboard, aba Configuracoes."; read -p "Pressione Enter para fechar..."; exit 1; }
[ -n "$URL" ] && [ -n "$TOKEN" ] || { echo "ERRO: preencha repoUrl e githubToken na conexao Railway (dashboard -> Configuracoes)."; read -p "Pressione Enter para fechar..."; exit 1; }
REMOTO=$(echo "$URL" | sed "s#https://#https://x-access-token:$TOKEN@#")
cd "$REPO" || { echo "ERRO: nao consegui entrar em $REPO"; read -p "Pressione Enter para fechar..."; exit 1; }
git add -A
if git diff --cached --quiet; then
  echo "Nada novo para publicar."
else
  git commit -m "publica: $(date '+%d/%m/%Y %H:%M')" >/dev/null
  if git push "$REMOTO" "HEAD:$BRANCH"; then
    echo "OK — push enviado. O Railway builda e publica sozinho em ~1-2 min."
  else
    echo "FALHOU o push — confira o githubToken (precisa de permissao de push no repo) e a internet."
  fi
fi
read -p "Pressione Enter para fechar..."
