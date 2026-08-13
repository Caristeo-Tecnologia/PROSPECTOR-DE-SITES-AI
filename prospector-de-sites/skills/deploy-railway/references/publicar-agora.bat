@echo off
rem Prospector de Sites — publica no Railway via git push (Windows).
cd /d "%~dp0"
set CFG=prospector-config.json
if not exist "%CFG%" (
  echo ERRO: prospector-config.json nao encontrado.
  pause
  exit /b 1
)
for /f "delims=" %%R in ('python -c "import json;print(json.load(open('prospector-config.json'))['railway'].get('repoPath',''))" 2^>nul') do set REPO=%%R
for /f "delims=" %%B in ('python -c "import json;print(json.load(open('prospector-config.json'))['railway'].get('branch') or 'main')" 2^>nul') do set BRANCH=%%B

if "%REPO%"=="" (
  echo ERRO: repoPath do Railway nao configurado. Preencha no dashboard, aba Configuracoes.
  pause
  exit /b 1
)
if not exist "%REPO%" (
  echo ERRO: pasta do repo nao existe: %REPO%
  pause
  exit /b 1
)

cd /d "%REPO%"
git add -A
git diff --cached --quiet
if errorlevel 1 (
  git commit -m "publica: %date% %time%" >nul
  git push origin HEAD:%BRANCH%
  if errorlevel 1 (
    echo FALHOU o push — confira se este repo tem login do git funcionando ^(SSH ou 'gh auth login'^) e a internet.
  ) else (
    echo OK — push enviado. O Railway builda e publica sozinho em ~1-2 min.
  )
) else (
  echo Nada novo para publicar.
)
pause
