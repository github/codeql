var http = require('http');

// These are exceptions where we override the routes
var handlers = {
  someKey: myIndirectHandler
};


function get(req, res) { // route handler
  handlers[req.params.key.toLowerCase()](req, res);
}

function myIndirectHandler(req, res) { // route handler
  res.setHeader('Content-Type', 'application/json');
  res.send("\"some result\"");
}

var server = http.createServer(get);
