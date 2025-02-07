let express = require('express');
let _ = require('lodash');

let app = express();

app.get('/hello', function(req, res) {
    _.merge({}, req.query.foo); // $ Alert
    _.merge({}, req.query); // $ TODO-MISSING: Alert - but not flagged

    _.merge({}, {
        value: req.query.value // $ TODO-MISSING: Alert
    }); // $ TODO-SPURIOUS: Alert

    let opts = {
      thing: req.query.value // wrapped and unwrapped value
    };
    _.merge({}, {
        value: opts.thing // $ TODO-MISSING: Alert
    }); // $ TODO-SPURIOUS: Alert
});
