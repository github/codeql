let express = require('express');
let _ = require('lodash');

let app = express();

app.get('/hello', function(req, res) {
    _.merge({}, req.query.foo); // $ Alert
    _.merge({}, req.query); // $ MISSING: Alert

    _.merge({}, { // $ Alert
        value: req.query.value // $ Source
    });

    let opts = {
      thing: req.query.value // $ Source - wrapped and unwrapped value
    };
    _.merge({}, { // $ Alert
        value: opts.thing
    });
});
