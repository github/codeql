var express = require('express'),
    app = express();
function f(res){
    res.set('X-Frame-Options', 'DENY');
}
app.get('/', function (req, res) {
    f(res);
});
