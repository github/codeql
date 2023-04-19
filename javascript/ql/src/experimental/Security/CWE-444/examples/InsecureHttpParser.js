const http = require('node:http');

http.createServer({
    insecureHTTPParser: true
}, (req, res) => {
    res.end('hello world\n');
});