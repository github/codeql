const express = require('express');
const app = express();
const testlib = require('testlib');

app.get('/before', (req, res) => {
    sink(req.injectedReqData); // OK [INCONSISTENCY] - happens before middleware
    sink(req.injectedResData); // OK - wrong parameter

    sink(res.injectedReqData); // OK - wrong parameter
    sink(res.injectedResData); // OK [INCONSISTENCY] - happens before middleware
});

app.use(testlib.middleware());

app.get('/after', (req, res) => {
    sink(req.injectedReqData); // NOT OK
    sink(req.injectedResData); // OK - wrong parameter

    sink(res.injectedReqData); // OK - wrong parameter
    sink(res.injectedResData); // NOT OK
});
