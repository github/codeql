const express = require('express')
const app = express()
const session = require('cookie-session')
const expiryDate = new Date(Date.now() + 60 * 60 * 1000)

app.use(session({
    name: 'session',
    keys: ['key1', 'key2'],
    cookie: {
        secure: true, // OK
        httpOnly: true,
        domain: 'example.com',
        path: 'foo/bar',
        expires: expiryDate
    }
}))

app.use(session({
    name: 'session',
    keys: ['key1', 'key2'],
    cookie: {
        secure: false, // NOT OK
        httpOnly: true,
        domain: 'example.com',
        path: 'foo/bar',
        expires: expiryDate
    }
}))
