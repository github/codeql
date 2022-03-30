var express = require('express');
var app = express();

app.get('/some/path', function(req, res) {  
  res.header(req.param("header"), req.param("val"));
  res.send("val");
});

function getHandler() {
    return function (req, res){}
}
app.use(getHandler());
