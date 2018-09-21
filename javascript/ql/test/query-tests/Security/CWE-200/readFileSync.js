var fs = require("fs");
var http = require("http");

let data = fs.readFileSync("input.txt");
try {
  let s = data.toString();
  // An object of options to indicate where to post to
  var post_options = {
      host: 'closure-compiler.appspot.com',
      port: '80',
      path: '/compile',
      method: 'POST',
      headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Content-Length': Buffer.byteLength(s) 
      }
  };

  // Set up the request
  var post_req = http.request(post_options, function(res) {
      res.setEncoding('utf8');
  });

  // post the data
  post_req.write(s);
  post_req.end();
} catch (e) {
}
