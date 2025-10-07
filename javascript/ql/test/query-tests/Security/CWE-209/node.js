var http = require('http');

http.createServer(function onRequest(req, res) {
  var body;
  try {
    body = handleRequest(req);
  }
  catch (err) { // $ Source
    res.statusCode = 500;
    res.setHeader("Content-Type", "text/plain");
    res.end(err.stack); // $ Alert
    return;
  }
  res.statusCode = 200;
  res.setHeader("Content-Type", "application/json");
  res.setHeader("Content-Length", body.length);
  res.end(body);
}).listen(3000);

http.createServer(function onRequest(req, res) {
  var body;
  try {
    body = handleRequest(req);
  }
  catch (err) {
    res.statusCode = 500;
    res.setHeader("Content-Type", "text/plain");
    log("Exception occurred", err.stack);
    res.end("An exception occurred");
    return;
  }
  res.statusCode = 200;
  res.setHeader("Content-Type", "application/json");
  res.setHeader("Content-Length", body.length);
  res.end(body);
}).listen(3000);
