let express = require('express');
let cookieParser = require('cookie-parser');

let app = express();

app.use(cookieParser());

app.post('/doSomethingTerrible', (req, res) => { // NOT OK - uses cookies
    if (req.cookies['secret'] === app.secret) {
        somethingTerrible();
    }
    res.end('Ok');
});

app.post('/doSomethingElse', (req, res) => { // OK - doesn't actually use cookies
    somethingElse(req.query['data']);
    res.end('Ok');
});

app.listen();
