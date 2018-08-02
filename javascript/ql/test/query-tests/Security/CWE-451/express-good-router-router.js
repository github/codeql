var express = require('express'),
    app = express();
var router1 = express.Router();
var router2 = express.Router();

app.use('/router1', router1);
router1.use('/router2', router2);
router2.get('/', function (req, res) {
    res.set('X-Frame-Options', 'DENY')
});
