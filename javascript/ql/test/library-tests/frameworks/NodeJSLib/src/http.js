var http = require('http');
var url = require('url');

var server = http.createServer(function(req, res) {
  // BAD: a request parameter is incorporated without validation into a URL redirect
  let target = url.parse(req.url, true).query.target;
  res.writeHead(302, { Location: target });
  req.headers.cookie;
  req.headers.foo;
})

http.createServer(function(req, res) {
  res.setHeader('Content-Type', 'text/html');  
  res.write("foo");
  res.end("bar");
})

http.request({ auth: "auth" });

function getHandler() {
    return function(req,res){}
}
http.createServer(getHandler());

var createServer = http.createServer;
createServer(function(req,res){});

http.createServer(function(req, res) {	  
  res.setHeader(req.query.myParam, "23")
  res.end("bar2");
});

function getArrowHandler() {
    return (req,res) => f();
}
http.createServer(getArrowHandler());
