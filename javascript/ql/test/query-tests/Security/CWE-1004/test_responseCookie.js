const express = require('express')
const app = express()

app.get('/a', function (req, res, next) {
    res.cookie('authkey', 'value',
        {
            maxAge: 9000000000,
            httpOnly: true, // GOOD
            secure: false
        });
    res.end('ok')
})

app.get('/a', function (req, res, next) {
    res.cookie('authkey', 'value',
        {
            maxAge: 9000000000,
            httpOnly: false, // BAD
            secure: false
        });
    res.end('ok')
})

app.get('/a', function (req, res, next) {
    res.cookie('authkey', 'value',
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
    res.cookie('authkey', 'value', options);
    res.end('ok')
})

app.get('/a', function (req, res, next) {
    let options = {
        maxAge: 9000000000,
        httpOnly: false, // BAD
        secure: false
    }
    res.cookie('authkey', 'value', options);
    res.end('ok')
})

app.get('/a', function (req, res, next) {
    let options = {
        maxAge: 9000000000
    }
    res.cookie('authkey', 'value', options); // BAD
    res.end('ok')
})

app.get('/a', function (req, res, next) {
    let options = {
        maxAge: 9000000000
    }
    options.httpOnly = false;
    res.cookie('authkey', 'value', options); // BAD
    res.end('ok')
})

app.get('/a', function (req, res, next) {
    let options = {
        maxAge: 9000000000
    }
    options.httpOnly = true;
    res.cookie('authkey', 'value', options); // GOOD
    res.end('ok')
})

app.get('/a', function (req, res, next) {
    let options = {
        maxAge: 9000000000,
        httpOnly: false,
    }
    options.httpOnly = false;
    res.cookie('authkey', 'value', options); // BAD
    res.end('ok')
})

app.get('/a', function (req, res, next) {
    let options = {
        maxAge: 9000000000,
        httpOnly: false,
    }
    options.httpOnly = false;
    let authKey = "blabla"
    res.cookie(authKey, 'value', options); // BAD, var name likely auth related
    res.end('ok')
})

app.get('/a', function (req, res, next) {
    let options = {
        maxAge: 9000000000,
        httpOnly: false,
    }
    options.httpOnly = false;
    let o = { authKey: "blabla" }
    res.cookie(o.authKey, 'value', options); // BAD, var name likely auth related
    res.end('ok')
})

app.get('/a', function (req, res, next) {
    let options = {
        maxAge: 9000000000,
        httpOnly: false,
    }
    options.httpOnly = false;
    let blabla = "authKey"
    res.cookie(blabla, 'value', options); // BAD, var name likely auth related
    res.end('ok')
})

app.get('/a', function (req, res, next) {
    let options = {
        maxAge: 9000000000,
        httpOnly: true,
    }
    options.httpOnly = true;
    res.cookie('authkey', 'value', options); // GOOD
    res.end('ok')
})

app.get('/a', function (req, res, next) {
    let options = {
        maxAge: 9000000000,
        httpOnly: false,
    }
    options.httpOnly = true;
    res.cookie('authkey', 'value', options); // GOOD
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