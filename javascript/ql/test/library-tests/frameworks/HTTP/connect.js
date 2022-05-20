var connect = require('connect');

var app = connect();

app.use(function (req, res){
    req.url;
    req.cookies.get();
});
