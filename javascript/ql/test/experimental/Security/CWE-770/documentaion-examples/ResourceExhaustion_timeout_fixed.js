var http = require("http"),
    url = require("url");

var server = http.createServer(function(req, res) {
	var delay = parseInt(url.parse(req.url, true).query.delay);

	if (delay > 1000) {
		res.statusCode = 400;
		res.end("Bad request.");
		return;
	}

	setTimeout(f, delay); // GOOD

});
