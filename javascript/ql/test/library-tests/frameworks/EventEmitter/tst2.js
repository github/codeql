var util = require('util');
var EventEmitter = require('events').EventEmitter;

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
