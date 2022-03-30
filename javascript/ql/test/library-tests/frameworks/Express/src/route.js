var express = require('express');
var router = express.Router();

router.route('/users/:user_id')
      .all(function(req, res, next) {});
