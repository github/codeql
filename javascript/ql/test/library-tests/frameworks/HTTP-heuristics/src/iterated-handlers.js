const express = require('express');
var app = express();

[function (req, res){}].forEach(function(h){
    app.use(h);
});
