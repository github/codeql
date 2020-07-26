const http = require('http');
const server = http.createServer((req, res) => {
    res.setHeader('Content-Type', 'text/html');
    // BAD
    res.setHeader("Set-Cookie", ["type=ninja", "language=javascript"]);
    res.writeHead(200, { 'Content-Type': 'text/plain' });
    res.end('ok');
});