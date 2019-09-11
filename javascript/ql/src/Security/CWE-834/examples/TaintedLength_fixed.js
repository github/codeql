var express = require('express');
var app = express();

app.post("/foo", (req, res) => {
    var obj = req.body;
    
    if (!(obj instanceof Array)) { // prevents DOS
        return [];
    }

    var ret = [];

    for (var i = 0; i < obj.length; i++) {
        ret.push(obj[i]);
    }
});