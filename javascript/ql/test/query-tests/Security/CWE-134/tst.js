let express = require('express');
let app = express();

app.get("/some/path", (req, res) => {
  util.format(req.query.format, arg);                        // $ Alert
  require('util').format(req.query.format, arg);             // $ Alert
  console.log(req.query.format, arg);                        // $ Alert
  console.error(req.query.format, arg);                      // $ Alert
  console.info(req.query.format, arg);                       // $ Alert
  util.log(req.query.format, arg);                           // $ Alert
  util.formatWithOptions(opts, req.query.format, arg);       // $ Alert
  require('printf')(req.query.format, arg);                  // $ Alert
  require('printf')(write_stream, req.query.format, arg);    // $ Alert
  require('printj').sprintf(req.query.format, arg);          // $ Alert
  require('printj').vsprintf(req.query.format, arg);         // $ Alert
  require('format-util')(req.query.format, arg);             // $ Alert
  require('string-template')(req.query.format, arg);         // $ Alert
  require('string-template/compile')(req.query.format, arg); // $ Alert
  util.format(req.query.format);
  console.debug(req.query.format, arg);                      // $ Alert
  console.warn(req.query.format, arg);                       // $ Alert
  console.trace(req.query.format, arg);                      // $ Alert
  console.assert(false, req.query.format);
  console.assert(false, req.query.format, arg);              // $ Alert
  require("sprintf-js").sprintf(req.query.format, arg);      // $ Alert
  require("sprintf-js").vsprintf(req.query.format, args);    // $ Alert
});
