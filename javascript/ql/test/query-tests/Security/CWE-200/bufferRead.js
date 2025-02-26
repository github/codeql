// adopted from https://stackoverflow.com/questions/36771266/what-is-the-use-of-fd-file-descriptor-in-node-js

const fs = require('fs');
var http = require('http');

var fileName = "foo.txt";

fs.exists(fileName, function (exists) {
   if (exists) {
    fs.stat(fileName, function (error, stats) {
      fs.open(fileName, "r", function (error, fd) {
        var buffer = new Buffer(stats.size); // $ Source[js/file-access-to-http]
        fs.read(fd, buffer, 0, buffer.length, null, function (error, bytesRead) {

          var postData = buffer.toString("utf8", 0, bytesRead);

          const options = {
            hostname: 'www.google.com',
            port: 80,
            path: '/upload',
            method: 'POST',
            headers: {
              'Content-Type': 'application/x-www-form-urlencoded',
              'Content-Length': Buffer.byteLength(postData)
            }
          };

          const req = http.request(options, (res) => {
            res.setEncoding('utf8');
          });

          req.write(postData); // $ Alert[js/file-access-to-http] - write data from file to request body
          req.end();
          });

          fs.close(fd);
        });
    });
  }
});
