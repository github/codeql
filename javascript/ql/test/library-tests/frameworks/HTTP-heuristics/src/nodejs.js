var http = require('http');

http.createServer(function(req, res){});

unknown.createServer(function(req, res){});

var createServer = http.createServer;
createServer(function(req, res){});

http.createServer().on("request", function(req, res){});
unknown.on("request", function(req, res){});
unknown.once("request", function(req, res){});

function getHandler(){
    return function(req, res){};
}
http.createServer(getHandler());
