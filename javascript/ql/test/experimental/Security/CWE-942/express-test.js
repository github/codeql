const cors = require('cors');
var express = require('express');

var https = require('https'),
    url = require('url');

var server = https.createServer(function () { });

server.on('request', function (req, res) {
    let user_origin = url.parse(req.url, true).query.origin;

    // BAD: CORS too permissive, default value is *
    var app1 = express();
    app1.use(cors());

    // GOOD: restrictive CORS 
    var app2 = express();
    var corsOptions2 = {
        origin: ["https://example1.com", "https://example2.com"],
    };
    app2.use(cors(corsOptions2));

    // BAD: CORS too permissive 
    var app3 = express();
    var corsOption3 = {
        origin: '*'
    };
    app3.use(cors(corsOption3));

    // BAD: CORS is controlled by user
    var app4 = express();
    var corsOption4 = {
        origin: user_origin
    };
    app4.use(cors(corsOption4));
});