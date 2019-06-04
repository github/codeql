let express = require('express');
let _ = require('lodash');

let app = express();

app.get('/hello', function(req, res) {
    _.merge({}, req.query.foo); // NOT OK
    _.merge({}, req.query); // NOT OK - but not flagged

    _.merge({}, {
        value: req.query.value // NOT OK
    });

    let opts = {
      thing: req.query.value // wrapped and unwrapped value
    };
    _.merge({}, {
        value: opts.thing // NOT OK
    });
});
