var https = require('https');
https.createServer(function (req, res) {});
https.createServer(o, function (req, res) {});
require('http2').createServer((req, res) => {});

require("tls").createServer((socket) => {
    socket.on("data", (data) => {})
});

const net = require('net');
const tls = require('tls');

const server = (isSecure ? tls : net).createServer(options, (socket) => {
    socket.on("data", (data) => {})
});