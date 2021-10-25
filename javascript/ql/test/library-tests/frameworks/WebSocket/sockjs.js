const express = require('express');
const http = require('http');
const sockjs = require('sockjs');

const app = express();
const server = http.createServer(app);
const sockjs_echo = sockjs.createServer({});
sockjs_echo.on('connection', function (conn) {
    conn.on('data', function (message) {
        var data = JSON.parse(message);
        conn.write(JSON.stringify(eval(data.test)));
    });
});

sockjs_echo.installHandlers(server, { prefix: '/echo' });
server.listen(9090, '127.0.0.1');
