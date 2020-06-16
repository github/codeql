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

app.post('/doWithCaptcha', (req, res) => { // OK - attacker can't guess the captcha value either
    if (req.session['captcha'] !== req.query['captcha']) {
        res.end("You guessed wrong, that 'u' was actually a 'U'. Try again.");
        return;
    }
    somethingElse(req.query['data']);
    res.end('Ok');
});

app.post('/user', (req, res) => { // NOT OK - access to req.user is unprotected
    somethingElse(req.user.name);
    res.end('Ok');
});

app.post('/session', (req, res) => { // NOT OK - access to req.session is unprotected
    somethingElse(req.session.name);
    res.end('Ok');
});

app.listen();
