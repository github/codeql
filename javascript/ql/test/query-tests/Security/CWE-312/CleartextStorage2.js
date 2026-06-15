var https = require('https');
var url = require('url');

var server = https.createServer(function(req, res) {
  let pw = url.parse(req.url, true).query.current_password; // $ Source[js/clear-text-storage-of-sensitive-data]
  res.writeHead(200, {
    'Set-Cookie': 'password=' + pw, // $ Alert[js/clear-text-storage-of-sensitive-data]
    'Content-Type': 'text/plain'
  });
});
