var express = require('express')
var cookieParser = require('cookie-parser')
var passport = require('passport')

var app = express()

app.use(cookieParser())
app.use(passport.authorize({ session: true }))

app.post('/changeEmail', function (req, res) {
    let newEmail = req.cookies["newEmail"];
})
