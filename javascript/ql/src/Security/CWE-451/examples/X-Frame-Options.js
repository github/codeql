var express = require('express'),
    app = express();


app.get('/', function (req, res) {
    res.set('X-Frame-Options', value)
    res.send('X-Frame-Options: ' + res.get('X-Frame-Options'))
})
