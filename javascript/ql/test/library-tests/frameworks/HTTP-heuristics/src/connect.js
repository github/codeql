var connect = require('connect');

var app = connect();

app.use(function(req,res){});

function getHandler(){
    return function(req, res){};
}
app.use(getHandler());

app.use(function(req,res){})
    .use(function(req,res){})
    .use(function(req,res){});
