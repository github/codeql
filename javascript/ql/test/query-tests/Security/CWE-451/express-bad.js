var express = require('express'),
    app = express(); // $ TODO-SPURIOUS: Alert


app.get('/', function (req, res) {
    res.send('X-Frame-Options: ' + res.get('X-Frame-Options'))
})
