var fs = require('fs'),
    http = require('http'),
    url = require('url'),
    sanitize = require('sanitize-filename'),
    pathModule = require('path')
    ;

var server = http.createServer(function(req, res) {
  let path = url.parse(req.url, true).query.path;
  res.write(fs.readFileSync(['public', path].join('/'))); // BAD - but not flagged because we have no array-steps [INCONSISTENCY]

  let parts = ['public', path];
  parts = parts.map(x => x.toLowerCase());
  res.write(fs.readFileSync(parts.join('/'))); // BAD - but not flagged because we have no array-steps [INCONSISTENCY]
});

server.listen();
