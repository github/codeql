// test NodeJS
const https = require('node:https');
const http = require('node:http');

https.createServer({
    insecureHTTPParser: true
}, (req, res) => {
    res.writeHead(200);
    res.end('hello world\n');
});

http.createServer({
    insecureHTTPParser: true
}, (req, res) => {
    res.writeHead(200);
    res.end('hello world\n');
});

http.get({ insecureHTTPParser: true }, (res) => {
    res.writeHead(200);
    res.end('hello world\n');
});

http.get('url', { insecureHTTPParser: true }, (res) => {
    res.writeHead(200);
    res.end('hello world\n');
});

http.request({ insecureHTTPParser: true }, (res) => {
    res.writeHead(200);
    res.end('hello world\n');
});

http.request('url', { insecureHTTPParser: true }, (res) => {
    res.writeHead(200);
    res.end('hello world\n');
});