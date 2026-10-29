var fs = require('fs'),
    http = require('http'),
    url = require('url');

var server = http.createServer(function(req, res) {
  let path = url.parse(req.url, true).query.path; // $ Source
	fs.readFileSync(path.substring(i, j));
	fs.readFileSync(path.substring(4)); // $ Alert
	fs.readFileSync(path.substring(0, i)); // $ Alert
	fs.readFileSync(path.substr(4)); // $ Alert
	fs.readFileSync(path.slice(4)); // $ Alert

	fs.readFileSync(path.concat(unknown)); // $ Alert
	fs.readFileSync(unknown.concat(path)); // $ Alert
	fs.readFileSync(unknown.concat(unknown, path)); // $ Alert

	fs.readFileSync(path.trim()); // $ Alert
	fs.readFileSync(path.toLowerCase()); // $ Alert

	fs.readFileSync(path.split('/')); // OK - readFile throws an exception when the filename is an array
	fs.readFileSync(path.split('/')[0]); // OK - for now
	fs.readFileSync(path.split('/')[i]); // $ Alert
	fs.readFileSync(path.split(/\//)[i]); // $ Alert
	fs.readFileSync(path.split("?")[0]); // $ Alert
	fs.readFileSync(path.split(unknown)[i]); // $ MISSING: Alert
	fs.readFileSync(path.split(unknown).whatever); // $ SPURIOUS: Alert
	fs.readFileSync(path.split(unknown)); // $ Alert
	fs.readFileSync(path.split("?")[i]); // $ MISSING: Alert
});

server.listen();
