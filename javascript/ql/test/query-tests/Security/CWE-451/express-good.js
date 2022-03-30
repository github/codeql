var express = require('express'),
    app = express();


app.get('/', function (req, res) {
    res.set('X-Frame-Options', 'DENY')
})
