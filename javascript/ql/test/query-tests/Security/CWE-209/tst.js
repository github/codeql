var http = require('http');

http.createServer(function onRequest(req, res) {
  try {
    throw new Error();
  } catch (e) {
    res.end(e);                        // NOT OK
    fail(res, e);
    res.end(e.message);                // OK
    res.end("Caught exception " + e);  // OK
    res.end(e.toString());             // OK
    res.end(`Caught exception ${e}.`); // OK
  }
});

function fail(res, e) {
  res.end(e.stack);                    // NOT OK
}
