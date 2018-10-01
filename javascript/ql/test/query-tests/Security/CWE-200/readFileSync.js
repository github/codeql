// adopted from https://stackoverflow.com/questions/6158933/how-to-make-an-http-post-request-in-node-js

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

  // BAD: post the data from file to request body
  post_req.write(s);
  post_req.end();
} catch (e) {
}
