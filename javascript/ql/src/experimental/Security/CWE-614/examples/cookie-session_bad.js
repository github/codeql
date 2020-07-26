const session = require('cookie-session')
const express = require('express')
const app = express()

const expiryDate = new Date(Date.now() + 60 * 60 * 1000)

app.use(session({
    name: 'session',
    keys: ['key1', 'key2'],
    cookie: {
        secure: false, // BAD
        httpOnly: true,
        domain: 'example.com',
        path: 'foo/bar',
        expires: expiryDate
    }
}))
