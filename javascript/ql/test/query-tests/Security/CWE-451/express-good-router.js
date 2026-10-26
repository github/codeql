var express = require('express'),
    app = express();
var router = express.Router();

router.get('/', function (req, res) {
    res.set('X-Frame-Options', 'DENY')
});

app.use('/router', router);
