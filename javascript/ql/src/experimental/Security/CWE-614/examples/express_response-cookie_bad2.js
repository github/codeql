const express = require('express')
const app = express()

app.get('/', function (req, res, next) {
    let options = {
        maxAge: 9000000000,
        httpOnly: true,
        secure: false // BAD
    }
    res.cookie('name', 'value', options);
    res.end('ok')
})
