var fs = require('fs'),
    http = require('http'),
    url = require('url');

var server = http.createServer(function(req, res) {
  let path = url.parse(req.url, true).query.path; // $ Source
  doRead(Promise.resolve(path));
});

async function doRead(pathPromise) {
  fs.readFileSync(await pathPromise); // $ Alert
  pathPromise.then(path => fs.readFileSync(path)); // $ Alert
}

server.listen();
