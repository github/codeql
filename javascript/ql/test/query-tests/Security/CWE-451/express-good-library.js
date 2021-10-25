var express = require('express'),
    app = express(),
    helmet = require('helmet');
app.use(helmet.frameguard());
app.get('/', function (req, res) {
});
