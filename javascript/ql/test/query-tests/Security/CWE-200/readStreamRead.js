const fs = require('fs');
var http = require('http');

var fileName = "foo.txt";

fs.exists(fileName, function (exists) {
   if (exists) {
    fs.stat(fileName, function (error, stats) {
      var readable = fs.createReadStream(fileName);
      readable.on('readable', () => {
        let chunk = readable.read();

        const options = {
          hostname: 'www.google.com',
          port: 80,
          path: '/upload',
          method: 'POST',
          headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
          }
        };

        const req = http.request(options, (res) => {
          res.setEncoding('utf8');
        });
        
        // write data to request body
        req.write(chunk);

        req.end(); 
      });

      fs.close(fd);
    });
  }
});