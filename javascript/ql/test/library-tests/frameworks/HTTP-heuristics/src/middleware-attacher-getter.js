var express = require('express');
function getAttacher1 (app) {
    return function() {
        app.use(function(req, res){});
    };
}

var app = express();
getAttacher1(app);
confuse(getAttacher2); // disable the type inference

function getAttacher2 (app) {
    return function(h) {
        app.use(h);
    };
}

var app = express();
getAttacher2(app)(function(req, res){});
confuse(getAttacher2); // disable the type inference
