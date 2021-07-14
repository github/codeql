const url = require("url");

require("http").createServer(function(req, resp) {
  var target = url.parse(req.url, true);
  sendTextResponse(resp, target.pathname)
});

function sendTextResponse(resp, text) {
  resp.writeHead(200, {"content-type": "text/plain; charset=utf-8"});
  resp.end(text);
}
