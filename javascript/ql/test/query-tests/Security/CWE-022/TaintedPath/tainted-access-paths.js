var fs = require('fs'),
    http = require('http'),
    url = require('url');

var server = http.createServer(function(req, res) {
  let path = url.parse(req.url, true).query.path;
  
  fs.readFileSync(path); // NOT OK

  var obj = bla ? something() : path;

  fs.readFileSync(obj.sub); // NOT OK

  obj.sub = "safe";

  fs.readFileSync(obj.sub); // OK

  obj.sub2 = "safe";
  if (random()) {
    fs.readFileSync(obj.sub2); // OK
  }

  if (random()) {
    obj.sub3 = "safe"
  }
  fs.readFileSync(obj.sub3); // NOT OK

  obj.sub4 = 
    fs.readFileSync(obj.sub4) ? // NOT OK
      fs.readFileSync(obj.sub4) : // NOT OK
      fs.readFileSync(obj.sub4); // NOT OK
});

server.listen();

var nodefs = require('node:fs');

var server2 = http.createServer(function(req, res) {
  let path = url.parse(req.url, true).query.path;
  nodefs.readFileSync(path); // NOT OK
});

server2.listen();