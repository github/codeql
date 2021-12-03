var express = require('express');

express.Router()
	.param('', h)
	.get('', h);

var app = express.createServer();
app.error(h);

var router = express.Router();
var root = router.route('/');
root.post('', h);
