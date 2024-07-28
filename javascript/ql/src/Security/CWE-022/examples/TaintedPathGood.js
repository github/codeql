const fs = require('fs'),
      http = require('http'),
      path = require('path'),
      url = require('url');

const ROOT = "/var/www/";

var server = http.createServer(function(req, res) {
  let filePath = url.parse(req.url, true).query.path;

  // GOOD: Verify that the file path is under the root directory
  filePath = fs.realpathSync(path.resolve(ROOT, filePath));
  if (!filePath.startsWith(ROOT)) {
    res.statusCode = 403;
    res.end();
    return;
  }
  res.write(fs.readFileSync(filePath, 'utf8'));
});