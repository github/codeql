var https = require('https');
var url = require('url');

var server = https.createServer(function(req, res) {
  let target = url.parse(req.url, true).query.target; // $ Source
  res.writeHead(302, { Location: target }); // $ Alert - a request parameter is incorporated without validation into a URL redirect
})

server.on('request', (req, res) => {
  let target = url.parse(req.url, true).query.target; // $ Source
  // OK - local redirects are unproblematic
  res.writeHead(302, { Location: '/local/' + target });
  res.writeHead(302, { Location: '/' + target }); // $ Alert - this could be a non-local redirect
  // OK - localhost redirects are unproblematic
  res.writeHead(302, { Location: '//localhost/' + target });
})

server.on('request', (req, res) => {
  let target = url.parse(req.url, true).query.target;
  // OK - comparison against known URLs
  if (target === 'semmle.com')
    res.writeHead(302, { Location: target });
})


server.on('request', (req, res) => {
  let target = url.parse(req.url, true).query.target; // $ Source
  let me = "me"
  res.writeHead(302, { Location: target + "?from=" + me }); // $ Alert - may be a global redirection
})
