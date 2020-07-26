const express = require('express')
const app = express()

app.get('/', function (req, res, next) {
    res.cookie('name', 'value',
        {
            maxAge: 9000000000,
            httpOnly: true,
            secure: true // GOOD
        });
    res.end('ok')
})