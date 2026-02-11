var express = require('express'),
    app = express(); // $ SPURIOUS: Alert

app.get('/', [
    function (req, res){
        res.send("Hello");
    },
    function (req, res) {
        res.set('X-Frame-Options', 'DENY');
    }
]);
