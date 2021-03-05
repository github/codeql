var app = require('express')();
app.set('view engine', 'hbs');

app.post('/path', function(req, res) {
    var bodyParameter = req.body.bodyParameter
    var queryParameter = req.query.queryParameter
    
    res.render('template', bodyParameter)
    res.render('template', queryParameter)
});