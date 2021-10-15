var e = require('express');
var router = e.Router();
router.get('/some/url', function(req, res) { req, res })
      .post('/some/other/url', function(request, result) { request, result });
var app = e();
app.use(router);
