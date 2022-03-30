var util = require("util");
var EventEmitter = require("events").EventEmitter;

var Connector = function() {
  if (!(this instanceof Connector)) {
    return new Connector(port, host, opts);
  }

  EventEmitter.call(this);
};

util.inherits(Connector, EventEmitter);

Connector.prototype.foo = function() {};

var em = new Connector();
em.on("foo", bar => {});
em.emit("foo", "bar");

var http = require("http");

let req1 = http.request(x, function(res) {
  res.on("data", function(data) {});
});
req1.on("socket", function(socket) {
  socket.on("data", function(data) {});
});

let req2 = http.request(x, function(res) {
  res.on("error", function(error) {});
});
req2.on("socket", function(socket) {
  socket.on("error", function(error) {});
});
