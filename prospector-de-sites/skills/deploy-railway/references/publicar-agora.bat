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
for /f "delims=" %%U in ('python -c "import json;print(json.load(open('prospector-config.json'))['railway'].get('repoUrl',''))" 2^>nul') do set URL=%%U
for /f "delims=" %%B in ('python -c "import json;print(json.load(open('prospector-config.json'))['railway'].get('branch') or 'main')" 2^>nul') do set BRANCH=%%B
for /f "delims=" %%T in ('python -c "import json;print(json.load(open('prospector-config.json'))['railway'].get('githubToken',''))" 2^>nul') do set TOKEN=%%T

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
if "%URL%"=="" (
  echo ERRO: preencha repoUrl na conexao Railway.
  pause
  exit /b 1
)
if "%TOKEN%"=="" (
  echo ERRO: preencha githubToken na conexao Railway.
  pause
  exit /b 1
)

set REMOTO=%URL:https://=https://x-access-token:%TOKEN%@%
cd /d "%REPO%"
git add -A
git diff --cached --quiet
if errorlevel 1 (
  git commit -m "publica: %date% %time%" >nul
  git push "%REMOTO%" HEAD:%BRANCH%
  if errorlevel 1 (
    echo FALHOU o push — confira o githubToken ^(precisa de permissao de push no repo^) e a internet.
  ) else (
    echo OK — push enviado. O Railway builda e publica sozinho em ~1-2 min.
  )
) else (
  echo Nada novo para publicar.
)
pause
