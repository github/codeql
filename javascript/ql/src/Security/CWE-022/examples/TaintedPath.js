var fs = require('fs'),
    http = require('http'),
    url = require('url');

var server = http.createServer(function(req, res) {
  let path = url.parse(req.url, true).query.path;

  // BAD: This could read any file on the file system
  res.write(fs.readFileSync(path));

  // BAD: This could still read any file on the file system
  res.write(fs.readFileSync("/home/user/" + path));
});
