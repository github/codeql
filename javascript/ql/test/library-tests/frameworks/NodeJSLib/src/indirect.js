var http = require('http');

function decorate(method) {
  return function(req, res) {
    return method.call(this, req, res);
  };
}

function Server(routes) {
  this.routes = routes;
}

Server.prototype = {
  requestHandler: function() {
    var routes = this.routes;
    return function(req, res) { // route handler
      var handler = routes[req.url] || routes['*'];

      return handler.call(this, req, res);
    }.bind(this);
  },
};

var routes = {
  '/foo/bar': decorate((req, res) => { // route handler
    res.end("foo");
  }),
  '/bar/foo': function(req, res) { // route handler
    res.end("bar");
  }
};

var appServer = new Server(routes);
var server = http.createServer(appServer.requestHandler());

server.listen(8080, () => {});