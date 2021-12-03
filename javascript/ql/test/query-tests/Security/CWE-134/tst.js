let express = require('express');
let app = express();

app.get("/some/path", (req, res) => {
  util.format(req.query.format, arg);                        // NOT OK
  require('util').format(req.query.format, arg);             // NOT OK
  console.log(req.query.format, arg);                        // NOT OK
  console.error(req.query.format, arg);                      // NOT OK
  console.info(req.query.format, arg);                       // NOT OK
  util.log(req.query.format, arg);                           // NOT OK
  util.formatWithOptions(opts, req.query.format, arg);       // NOT OK
  require('printf')(req.query.format, arg);                  // NOT OK
  require('printf')(write_stream, req.query.format, arg);    // NOT OK
  require('printj').sprintf(req.query.format, arg);          // NOT OK
  require('printj').vsprintf(req.query.format, arg);         // NOT OK
  require('format-util')(req.query.format, arg);             // NOT OK
  require('string-template')(req.query.format, arg);         // NOT OK
  require('string-template/compile')(req.query.format, arg); // NOT OK
  util.format(req.query.format);                             // OK
  console.debug(req.query.format, arg);                      // NOT OK
  console.warn(req.query.format, arg);                       // NOT OK
  console.trace(req.query.format, arg);                      // NOT OK
  console.assert(false, req.query.format);                   // OK
  console.assert(false, req.query.format, arg);              // NOT OK
  require("sprintf-js").sprintf(req.query.format, arg);      // NOT OK
  require("sprintf-js").vsprintf(req.query.format, args);    // NOT OK
});
