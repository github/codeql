const cors = require('cors');
var express = require('express');

var https = require('https'),
    url = require('url');

var server = https.createServer(function () { });

server.on('request', function (req, res) {
    let user_origin = url.parse(req.url, true).query.origin; // $ Source

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
        origin: '*' // $ Alert
    };
    app3.use(cors(corsOption3));

    // BAD: CORS is controlled by user
    var app4 = express();
    var corsOption4 = {
        origin: user_origin // $ Alert
    };
    app4.use(cors(corsOption4));

    // GOOD: CORS allows any origin but credentials are disabled (safe pattern)
    var app5 = express();
    var corsOption5 = {
        origin: '*',
        credentials: false
    };
    app5.use(cors(corsOption5));

    // BAD: CORS allows any origin with credentials enabled
    var app6 = express();
    var corsOption6 = {
        origin: '*',       // $ Alert  
        credentials: true
    };
    app6.use(cors(corsOption6));
});