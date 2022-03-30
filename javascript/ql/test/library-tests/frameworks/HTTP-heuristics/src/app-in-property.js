var express = require('express');

var obj = {};
obj.app = express();

obj.app.use(function(req, res){});


function getConfig(){
    var obj = {};
    obj.app = express();
    return obj;
}
getConfig().app.use(function(req, res){});
