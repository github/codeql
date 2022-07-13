var http = require("http"),
    url = require("url");

var server = http.createServer(function(req, res) {
	var size = parseInt(url.parse(req.url, true).query.size);

	if (size > 1024) {
		res.statusCode = 400;
		res.end("Bad request.");
		return;
	}

	let buffer = Buffer.alloc(size); // GOOD

	// ... use the buffer
});