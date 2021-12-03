var express = require('express');
function attacher (app, server) {
    app.use(function(req, res){});
}

var app = express();
attacher(app);
