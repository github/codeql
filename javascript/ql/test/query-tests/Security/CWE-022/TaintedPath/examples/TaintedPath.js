const fs = require('fs'),
      http = require('http'),
      url = require('url');

const ROOT = "/var/www/";

var server = http.createServer(function(req, res) {
  let filePath = url.parse(req.url, true).query.path; // $ Source

  res.write(fs.readFileSync(ROOT + filePath, 'utf8')); // $ Alert - This function uses unsanitized input that can read any file on the file system.
});