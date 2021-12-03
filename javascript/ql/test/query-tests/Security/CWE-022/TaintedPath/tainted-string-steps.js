var fs = require('fs'),
    http = require('http'),
    url = require('url');

var server = http.createServer(function(req, res) {
  let path = url.parse(req.url, true).query.path;
	fs.readFileSync(path.substring(i, j)); // OK
	fs.readFileSync(path.substring(4)); // NOT OK
	fs.readFileSync(path.substring(0, i)); // NOT OK
	fs.readFileSync(path.substr(4)); // NOT OK
	fs.readFileSync(path.slice(4)); // NOT OK

	fs.readFileSync(path.concat(unknown)); // NOT OK
	fs.readFileSync(unknown.concat(path)); // NOT OK
	fs.readFileSync(unknown.concat(unknown, path)); // NOT OK

	fs.readFileSync(path.trim()); // NOT OK
	fs.readFileSync(path.toLowerCase()); // NOT OK

	fs.readFileSync(path.split('/')); // OK (readFile throws an exception when the filename is an array)
	fs.readFileSync(path.split('/')[0]); // OK -- for now
	fs.readFileSync(path.split('/')[i]); // NOT OK
	fs.readFileSync(path.split(/\//)[i]); // NOT OK
	fs.readFileSync(path.split("?")[0]); // NOT OK
	fs.readFileSync(path.split(unknown)[i]); // NOT OK -- but not yet flagged [INCONSISTENCY]
	fs.readFileSync(path.split(unknown).whatever); // OK -- but still flagged [INCONSISTENCY]
	fs.readFileSync(path.split(unknown)); // NOT OK
	fs.readFileSync(path.split("?")[i]); // NOT OK -- but not yet flagged [INCONSISTENCY]
});

server.listen();
