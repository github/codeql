var https = require('https');
var url = require('url');

var server = https.createServer(function(req, res) {
  // BAD: a request parameter is incorporated without validation into a URL redirect
  let target = url.parse(req.url, true).query.target;
  res.writeHead(302, { Location: target });
  req.headers.cookie;
  req.headers.foo;
})

https.createServer(function(req, res) {
  res.setHeader('Content-Type', 'text/html');
  res.write("foo");
  res.end("bar");
})

https.request({ auth: "auth" });

