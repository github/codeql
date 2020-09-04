const express = require('express')
const app = express()

app.get('/a', function (req, res, next) {
    res.cookie('name', 'value',
        {
            maxAge: 9000000000,
            httpOnly: true,
            secure: false // NOT OK
        });
    res.end('ok')
})

app.get('/b', function (req, res, next) {
    let options = {
        maxAge: 9000000000,
        httpOnly: true,
        secure: false // NOT OK
    }
    res.cookie('name', 'value', options);
    res.end('ok')
})

app.get('/c', function (req, res, next) {
    res.cookie('name', 'value',
        {
            maxAge: 9000000000,
            httpOnly: true,
            secure: true // OK
        });
    res.end('ok')
})

