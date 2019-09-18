var https = require('https');
var url = require('url');

var server = https.createServer(function(req, res) {
  let pw = url.parse(req.url, true).query.current_password;
  res.writeHead(200, {
    'Set-Cookie': 'password=' + pw,
    'Content-Type': 'text/plain'
  });
});
