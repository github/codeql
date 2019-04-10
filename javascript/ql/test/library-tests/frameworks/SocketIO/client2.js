var sock = require("socket.io-client")("ws://localhost");
var sock2 = require("socket.io-client").connect("http://example.com/foo/bar?q=v#abc");

sock.on('message', (x, y) => {
  console.log(x, y);
})

sock.on(eventName(), (msg) => {});

sock.on('event', (x, cb) => {
  cb("received");
});

sock.emit('data', "hi", "there");

sock.write("do you copy?", () => {});

sock2.on('message', require('./handler'));