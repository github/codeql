var fs = require('fs'),
    http = require('http'),
    url = require('url');

var server = http.createServer(function(req, res) {
  let path = url.parse(req.url, true).query.path;
  doRead(Promise.resolve(path));
});

async function doRead(pathPromise) {
  fs.readFileSync(await pathPromise); // NOT OK
  pathPromise.then(path => fs.readFileSync(path)); // NO TOK
}

server.listen();
