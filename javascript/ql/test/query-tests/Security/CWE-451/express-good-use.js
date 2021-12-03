var express = require('express'),
    app = express();
var router = express.Router();

app.use(function (req, res) {
    res.set('X-Frame-Options', 'DENY')
});
