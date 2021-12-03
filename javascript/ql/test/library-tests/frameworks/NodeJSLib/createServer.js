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


const http = require("http");

(function () {
    function MyApp(data) {this.data = data};
    MyApp.prototype.getRequestHandler = function () {
        return this.handleRequest.bind(this)
    }
    MyApp.prototype.handleRequest = function (req, res) {
        res.end(this.data);
    }

    var app = new MyApp("data");

    const srv = http.createServer(app.getRequestHandler());
})();