var https = require('https');
var url = require('url');

var server = https.createServer(function(req, res) {
  let a = url.parse(req.url, true).query.AccountName;
  res.writeHead(200, {
    'Set-Cookie': 'AccountName=' + a,
    'Content-Type': 'text/plain'
  });
});
