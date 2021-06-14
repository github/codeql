const express = require('express')
const app = express()

app.get('/a', function (req, res, next) {
    res.cookie('session', 'value',
        {
            maxAge: 9000000000,
            httpOnly: true, // GOOD
            secure: false
        });
    res.end('ok')
})

app.get('/a', function (req, res, next) {
    res.cookie('session', 'value',
        {
            maxAge: 9000000000,
            httpOnly: false, // BAD
            secure: false
        });
    res.end('ok')
})

app.get('/a', function (req, res, next) {
    res.cookie('session', 'value',
        {
            maxAge: 9000000000
        });
    res.end('ok') // BAD
})

app.get('/a', function (req, res, next) {
    let options = {
        maxAge: 9000000000,
        httpOnly: true, // GOOD
        secure: false
    }
    res.cookie('session', 'value', options);
    res.end('ok')
})

app.get('/a', function (req, res, next) {
    let options = {
        maxAge: 9000000000,
        httpOnly: false, // BAD
        secure: false
    }
    res.cookie('session', 'value', options);
    res.end('ok')
})

app.get('/a', function (req, res, next) {
    let options = {
        maxAge: 9000000000
    }
    res.cookie('session', 'value', options); // BAD
    res.end('ok')
})

app.get('/a', function (req, res, next) {
    let options = {
        maxAge: 9000000000
    }
    options.httpOnly = false;
    res.cookie('session', 'value', options); // BAD
    res.end('ok')
})

app.get('/a', function (req, res, next) {
    let options = {
        maxAge: 9000000000
    }
    options.httpOnly = true;
    res.cookie('session', 'value', options); // GOOD
    res.end('ok')
})

app.get('/a', function (req, res, next) {
    let options = {
        maxAge: 9000000000,
        httpOnly: false,
    }
    options.httpOnly = false;
    res.cookie('session', 'value', options); // BAD
    res.end('ok')
})

app.get('/a', function (req, res, next) {
    let options = {
        maxAge: 9000000000,
        httpOnly: false,
    }
    options.httpOnly = false;
    let session = "blabla"
    res.cookie(session, 'value', options); // BAD, var name likely auth related
    res.end('ok')
})

app.get('/a', function (req, res, next) {
    let options = {
        maxAge: 9000000000,
        httpOnly: false,
    }
    options.httpOnly = false;
    let o = { session: "blabla" }
    res.cookie(o.session, 'value', options); // BAD, var name likely auth related
    res.end('ok')
})

app.get('/a', function (req, res, next) {
    let options = {
        maxAge: 9000000000,
        httpOnly: false,
    }
    options.httpOnly = false;
    let blabla = "session"
    res.cookie(blabla, 'value', options); // BAD, var name likely auth related
    res.end('ok')
})

app.get('/a', function (req, res, next) {
    let options = {
        maxAge: 9000000000,
        httpOnly: true,
    }
    options.httpOnly = true;
    res.cookie('session', 'value', options); // GOOD
    res.end('ok')
})

app.get('/a', function (req, res, next) {
    let options = {
        maxAge: 9000000000,
        httpOnly: false,
    }
    options.httpOnly = true;
    res.cookie('session', 'value', options); // GOOD
    res.end('ok')
})

app.get('/a', function (req, res, next) {
    let options = {
        maxAge: 9000000000,
        httpOnly: false,
    }
    res.cookie('mycookie', 'value', options); // GOOD, name likely is not auth sensitive
    res.end('ok')
})