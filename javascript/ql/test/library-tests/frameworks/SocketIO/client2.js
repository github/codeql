var sock = require("socket.io-client")("ws://localhost");
require("socket.io-client").connect("http://example.com/foo/bar?q=v#abc");

sock.on('message', (x, y) => {
  console.log(x, y);
})

sock.on(eventName(), (msg) => {});

sock.on('data', (x, cb) => {
  cb("received");
});

sock.emit('data', "hi", "there");

sock.write("do you copy?", () => {});
