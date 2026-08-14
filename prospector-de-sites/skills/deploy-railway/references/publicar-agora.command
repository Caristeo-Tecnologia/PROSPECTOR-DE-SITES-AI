#!/bin/bash
# Prospector de Sites — publica no Railway via git push (Mac).
cd "$(dirname "$0")"
CFG=prospector-config.json
[ -f "$CFG" ] || { echo "ERRO: prospector-config.json nao encontrado."; read -p "Pressione Enter para fechar..."; exit 1; }
REPO=$(python3 -c "import json;print(json.load(open('$CFG'))['railway'].get('repoPath',''))" 2>/dev/null)
BRANCH=$(python3 -c "import json;print(json.load(open('$CFG'))['railway'].get('branch') or 'main')" 2>/dev/null)
[ -n "$REPO" ] && [ -d "$REPO" ] || { echo "ERRO: repoPath do Railway nao configurado ou pasta inexistente. Preencha no dashboard, aba Configuracoes."; read -p "Pressione Enter para fechar..."; exit 1; }
[ -d "$REPO/.git" ] || { echo "ERRO: $REPO nao e um repositorio git (sem pasta .git). Confira o repoPath no dashboard — este script NUNCA cria um repo novo."; read -p "Pressione Enter para fechar..."; exit 1; }
cd "$REPO" || { echo "ERRO: nao consegui entrar em $REPO"; read -p "Pressione Enter para fechar..."; exit 1; }
git add -A
if git diff --cached --quiet; then
  echo "Nada novo para publicar."
else
  git commit -m "publica: $(date '+%d/%m/%Y %H:%M')" >/dev/null
  if git push origin "HEAD:$BRANCH"; then
    echo "OK — push enviado. O Railway builda e publica sozinho em ~1-2 min."
  else
    echo "FALHOU o push — confira se este repo tem login do git funcionando (SSH ou 'gh auth login') e a internet."
  fi
fi
read -p "Pressione Enter para fechar..."
