var express = require('express');

var app = express();
var config = {
    handler: function(req, res){}
}
app.use(config.handler);


function getConfig() {
    return {
        handler: function(req, res){}
    }
}
app.use(getConfig().handler);
