var fs = require('fs'),
    http = require('http'),
    url = require('url'),
    sanitize = require('sanitize-filename'),
    pathModule = require('path')
    ;

var server = http.createServer(function(req, res) {
  let path = url.parse(req.url, true).query.path;

  // BAD: This could read any file on the file system
  res.write(fs.readFileSync(path));

  if (path === 'foo.txt')
    res.write(fs.readFileSync(path)); // GOOD: Path is compared to white-list

  let path2 = path;
  path2 ||= res.write(fs.readFileSync(path2)); // GOOD: path is falsy

  let path3 = path;
  path3 &&= res.write(fs.readFileSync(path3)); // BAD: path is truthy

  let path4 = path;
  path4 ??= res.write(fs.readFileSync(path4)); // GOOD - path is null or undefined - but we don't capture that. [INCONSISTENCY]

  let path5 = path;
  path5 &&= "clean";
  res.write(fs.readFileSync(path5)); // GOOD: path is either falsy or "clean";

  let path6 = path;
  path6 ||= "clean";
  res.write(fs.readFileSync(path6)); // BAD: path can still be tainted

});
