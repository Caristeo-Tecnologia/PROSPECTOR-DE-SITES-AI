// Prospector de Sites — servidor estático mínimo para Railway (sem dependências).
// Serve tudo que estiver em public/, na porta que o Railway injetar em process.env.PORT.
const http = require('http');
const fs = require('fs');
const path = require('path');

const PASTA = path.join(__dirname, 'public');
const PORTA = process.env.PORT || 3000;
const TIPOS = {
  '.html': 'text/html; charset=utf-8', '.css': 'text/css', '.js': 'application/javascript',
  '.png': 'image/png', '.jpg': 'image/jpeg', '.jpeg': 'image/jpeg', '.svg': 'image/svg+xml',
  '.ico': 'image/x-icon', '.json': 'application/json', '.webp': 'image/webp',
};

http.createServer((req, res) => {
  let rel = decodeURIComponent(req.url.split('?')[0]);
  if (rel.endsWith('/')) rel += 'index.html';
  const alvo = path.normalize(path.join(PASTA, rel));
  if (!alvo.startsWith(PASTA)) {
    res.writeHead(403);
    return res.end('Proibido');
  }
  fs.readFile(alvo, (erro, dados) => {
    if (erro) {
      res.writeHead(404);
      return res.end('Nao encontrado');
    }
    res.writeHead(200, { 'Content-Type': TIPOS[path.extname(alvo)] || 'application/octet-stream' });
    res.end(dados);
  });
}).listen(PORTA, () => console.log('Servindo public/ na porta ' + PORTA));
