var http = require('http');

http.createServer(function onRequest(req, res) {
  try {
    throw new Error();
  } catch (e) { // $ Source
    res.end(e);                        // $ Alert
    fail(res, e);
    res.end(e.message);
    res.end("Caught exception " + e);
    res.end(e.toString());
    res.end(`Caught exception ${e}.`);
  }
});

function fail(res, e) {
  res.end(e.stack);                    // $ Alert
}
