var http = require('http');
var url = require('url');

var server = http.createServer(function(req, res) {
  // BAD: a request parameter is incorporated without validation into a URL redirect
  let target = url.parse(req.url, true).query.target;
  res.writeHead(302, { Location: target });
  req.headers.cookie;
  req.headers.foo;
})

http.createServer(function(req, res) {
  res.setHeader('Content-Type', 'text/html');  
  res.write("foo");
  res.end("bar");
})

http.request({ auth: "auth" });

function makeClientRequests() {
    var req = http.request({}, (response) => {
      response.statusCode;
      response.on('data', (chunk) => {
        chunk[0];
      })
    })
    var post = http.request({url: 'https://example.com', method: 'POST'});
    
    post.on('response', (response) => {
      response.on('data', (chunk) => {
        chunk[0];
      });
    });
    
    post.on('redirect', (redirect) => { // Electron-specific APIs, not present on Node.js ClientRequests
      redirect.statusCode;
      post.followRedirect();
    });
    
    post.on('login', (authInfo, callback) => {
      authInfo.host;
      callback('username', 'password');
    });
    
    post.on('error', (error) => {
      error.something;
    });
    
    post.setHeader('referer', 'https://example.com');
    post.write('stuff');
    post.end('more stuff');
}

function getHandler() {
    return function(req,res){}
}
http.createServer(getHandler());

var createServer = http.createServer;
createServer(function(req,res){});

http.createServer(function(req, res) {	  
  res.setHeader(req.query.myParam, "23")
  res.end("bar2");
});

function getArrowHandler() {
    return (req,res) => f();
}
http.createServer(getArrowHandler());

http.createServer(function (req, res) {
  req.on("data", chunk => { // RemoteFlowSource
    res.send(chunk); 
  })
});

var httpProxy = require('http-proxy');
var proxy = httpProxy.createProxyServer({});
 
proxy.on('proxyReq', function(proxyReq, req, res, options) {
  req.on("data", chunk => { // RemoteFlowSource
    res.send(chunk); 
  });
  res.end("bla");
});