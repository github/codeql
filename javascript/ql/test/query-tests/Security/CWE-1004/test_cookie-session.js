const express = require('express')
const app = express()
const session = require('cookie-session')
const expiryDate = new Date(Date.now() + 60 * 60 * 1000)

app.use(session({
    name: 'session',
    keys: ['key1', 'key2'],
    httpOnly: true, // GOOD
}))

app.use(session({
    name: 'session',
    keys: ['key1', 'key2'],
    httpOnly: false // BAD
}))

app.use(session({
    name: 'session',
    keys: ['key1', 'key2'],
    secure: true // GOOD, httpOnly is true by default
}))

var sess = {
    name: 'session',
    keys: ['key1', 'key2'],
}

sess.httpOnly = false;
app.use(session(sess)) // BAD

var sess2 = {
    name: 'session',
    keys: ['key1', 'key2'],
    httpOnly: true,
}

sess2.httpOnly = false;
app.use(session(sess2)) // BAD

var sess3 = {
    name: 'mycookie',
    keys: ['key1', 'key2'],
    httpOnly: true,
}

sess3.httpOnly = false;
app.use(session(sess3)) // BAD, It is a session cookie, name doesn't matter

var flag = false
var flag2 = flag
app.use(session({
    name: 'session',
    keys: ['key1', 'key2'],
    httpOnly: flag2 // BAD
}))