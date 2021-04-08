const http = require('http');

function test1() {
    const server = http.createServer((req, res) => {
        res.setHeader('Content-Type', 'text/html');
        // NOT OK
        res.setHeader("Set-Cookie", ["type=ninja", "language=javascript"]);
        res.writeHead(200, { 'Content-Type': 'text/plain' });
        res.end('ok');
    });
}


function test2() {
    const server = http.createServer((req, res) => {
        res.setHeader('Content-Type', 'text/html');
        // OK
        res.setHeader("Set-Cookie", ["type=ninja; Secure", "language=javascript; secure"]);
        res.writeHead(200, { 'Content-Type': 'text/plain' });
        res.end('ok');
    });
}
