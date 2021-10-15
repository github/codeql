const http = require('http');
const url = require('url');

const server = http.createServer((req, res) => {
    let q = url.parse(req.url, true);

    // GOOD: remove newlines from user controlled input before logging
    let username = q.query.username.replace(/\n|\r/g, "");

    console.info(`[INFO] User: ${username}`);
});

server.listen(3000, '127.0.0.1', () => {});
