const express = require('express')
const app = express()
const session = require('express-session')

app.use(session({
    name: 'session',
    keys: ['key1', 'key2'],
    cookie: { httpOnly: true }, // GOOD
}))

app.use(session({
    name: 'session',
    keys: ['key1', 'key2'],
    cookie: { httpOnly: false } // BAD
}))

app.use(session({
    name: 'session',
    keys: ['key1', 'key2'],
    cookie: { secure: true } // GOOD, httpOnly is true by default
}))

app.use(session({ // GOOD, httpOnly is true by default
    name: 'session',
    keys: ['key1', 'key2']
}))

app.use(session({
    name: 'mycookie',
    keys: ['key1', 'key2'],
    cookie: { httpOnly: false } // BAD, It is a session cookie, name doesn't matter
}))
