var http = require("http"),
    url = require("url");

var server = http.createServer(function(req, res) {
	var delay = parseInt(url.parse(req.url, true).query.delay);

	setTimeout(f, delay); // BAD

});
