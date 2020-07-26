const http = require('http');
const server = http.createServer((req, res) => {
    res.setHeader('Content-Type', 'text/html');
    // GOOD
    res.setHeader("Set-Cookie", ["type=ninja; Secure", "language=javascript; secure"]);
    res.writeHead(200, { 'Content-Type': 'text/plain' });
    res.end('ok');
});