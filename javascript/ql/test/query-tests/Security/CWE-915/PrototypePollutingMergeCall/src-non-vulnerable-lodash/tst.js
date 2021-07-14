let express = require('express');
let _ = require('lodash');

let app = express();

app.get('/hello', function(req, res) {
    _.merge({}, req.query.foo); // OK
});
