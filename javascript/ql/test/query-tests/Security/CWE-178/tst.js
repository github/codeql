const express = require('express');
const app = express();
const unknown = require('~something/blah');

app.all(/\/.*/, unknown()); // OK - does not contain letters
app.all(/\/.*/i, unknown()); // OK

app.all(/\/foo\/.*/, unknown()); // NOT OK
app.all(/\/foo\/.*/i, unknown()); // OK - case insensitive

app.use(/\/x\/#\d{6}/, express.static('images/')); // OK - not a middleware

app.get(
    new RegExp('^/foo(.*)?'), // NOT OK - case sensitive
    unknown(),
    function(req, res, next) {
        if (req.params.blah) {
            next();
        }
    }
);

app.get(
    new RegExp('^/foo(.*)?', 'i'), // OK - case insensitive
    unknown(),
    function(req, res, next) {
        if (req.params.blah) {
            next();
        }
    }
);

app.get(
    new RegExp('^/foo(.*)?'), // OK - not a middleware
    unknown(),
    function(req,res) {
        res.send('Hello World!');
    }
);

app.use(/\/foo\/([0-9]+)/, (req, res, next) => { // NOT OK - case sensitive
    unknown(req);
    next();
});

app.use(/\/foo\/([0-9]+)/i, (req, res, next) => { // OK - case insensitive
    unknown(req);
    next();
});


app.use(/\/foo\/([0-9]+)/, (req, res) => { // OK - not middleware
    unknown(req, res);
});

app.use(/\/foo\/([0-9]+)/i, (req, res) => { // OK - not middleware (also case insensitive)
    unknown(req, res);
});

app.get('/foo/:param', (req, res) => { // OK - not a middleware
});
