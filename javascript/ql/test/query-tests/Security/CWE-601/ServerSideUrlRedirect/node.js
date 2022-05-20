var https = require('https');
var url = require('url');

var server = https.createServer(function(req, res) {
  let target = url.parse(req.url, true).query.target;
  res.writeHead(302, { Location: target }); // BAD: a request parameter is incorporated without validation into a URL redirect
})

server.on('request', (req, res) => {
  let target = url.parse(req.url, true).query.target;
  // GOOD: local redirects are unproblematic
  res.writeHead(302, { Location: '/local/' + target });
  // BAD: this could be a non-local redirect
  res.writeHead(302, { Location: '/' + target });
  // GOOD: localhost redirects are unproblematic
  res.writeHead(302, { Location: '//localhost/' + target });
})

server.on('request', (req, res) => {
  let target = url.parse(req.url, true).query.target;
  // GOOD: comparison against known URLs
  if (target === 'semmle.com')
    res.writeHead(302, { Location: target });
})


server.on('request', (req, res) => {
  let target = url.parse(req.url, true).query.target;
  let me = "me"
  // BAD: may be a global redirection
  res.writeHead(302, { Location: target + "?from=" + me });
})
