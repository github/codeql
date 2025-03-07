var fs = require('fs'),
    http = require('http'),
    url = require('url');

var server = http.createServer(function(req, res) {
  let path = url.parse(req.url, true).query.path; // $ Source
  
  fs.readFileSync(path); // $ Alert

  var obj = bla ? something() : path;

  fs.readFileSync(obj.sub); // $ Alert

  obj.sub = "safe";

  fs.readFileSync(obj.sub);

  obj.sub2 = "safe";
  if (random()) {
    fs.readFileSync(obj.sub2);
  }

  if (random()) {
    obj.sub3 = "safe"
  }
  fs.readFileSync(obj.sub3); // $ Alert

  obj.sub4 = 
    fs.readFileSync(obj.sub4) ? // $ Alert
      fs.readFileSync(obj.sub4) : // $ Alert
      fs.readFileSync(obj.sub4); // $ Alert
});

server.listen();

var nodefs = require('node:fs');

var server2 = http.createServer(function(req, res) {
  let path = url.parse(req.url, true).query.path; // $ Source
  nodefs.readFileSync(path); // $ Alert
});

server2.listen();

const chownr = require("chownr");

var server3 = http.createServer(function (req, res) {
  let path = url.parse(req.url, true).query.path; // $ Source
  chownr(path, "someuid", "somegid", function (err) {}); // $ Alert
});
