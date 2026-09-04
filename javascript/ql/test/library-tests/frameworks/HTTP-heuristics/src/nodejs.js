var http = require('http');

http.createServer(function(req, res){});

unknown.createServer(function(req, res){}); // $ Alert[js/unpromoted-route-setup-candidate]

var createServer = http.createServer;
createServer(function(req, res){});

http.createServer().on("request", function(req, res){});
unknown.on("request", function(req, res){}); // $ Alert[js/unpromoted-route-setup-candidate]
unknown.once("request", function(req, res){}); // $ Alert[js/unpromoted-route-setup-candidate]

function getHandler(){
    return function(req, res){};
}
http.createServer(getHandler());
