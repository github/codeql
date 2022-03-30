var express = require('express');
var app = express();

app.post("/foo", (req, res) => {
    var obj = req.body;

    var ret = [];

    // Potential DoS if obj.length is large.
    for (var i = 0; i < obj.length; i++) {
        ret.push(obj[i]);
    }
});
