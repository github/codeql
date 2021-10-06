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

const js_cookie = require('js-cookie')
js_cookie.set('key', 'value', { secure: false }); // NOT OK
js_cookie.set('key', 'value', { secure: true }); // OK

const http = require('http');

function test1() {
    const server = http.createServer((req, res) => {
        res.setHeader('Content-Type', 'text/html');
        // BAD
        res.setHeader("Set-Cookie", "type=ninja");
        res.writeHead(200, { 'Content-Type': 'text/plain' });
        res.end('ok');
    });
}

function test2() {
    const server = http.createServer((req, res) => {
        res.setHeader('Content-Type', 'text/html');
        // GOOD
        res.setHeader("Set-Cookie", "type=ninja; Secure");
        res.writeHead(200, { 'Content-Type': 'text/plain' });
        res.end('ok');
    });
}

function test3() {
    const server = http.createServer((req, res) => {
        res.setHeader('Content-Type', 'text/html');
        // BAD
        res.setHeader("Set-Cookie", ["type=ninja", "language=javascript"]);
        res.writeHead(200, { 'Content-Type': 'text/plain' });
        res.end('ok');
    });
}

function test4() {
    const server = http.createServer((req, res) => {
        res.setHeader('Content-Type', 'text/html');
        // GOOD
        res.setHeader("Set-Cookie", ["type=ninja; Secure"]);
        res.writeHead(200, { 'Content-Type': 'text/plain' });
        res.end('ok');
    });
}

function test5() {
    const server = http.createServer((req, res) => {
        res.setHeader('Content-Type', 'text/html');
        // GOOD, case insensitive
        res.setHeader("Set-Cookie", ["type=ninja; secure"]);
        res.writeHead(200, { 'Content-Type': 'text/plain' });
        res.end('ok');
    });
}

function test6() {
    const server = http.createServer((req, res) => {
        res.setHeader('Content-Type', 'text/html');
        // BAD
        res.setHeader("Set-Cookie", ["type=ninja; secure", "language=javascript"]);
        res.writeHead(200, { 'Content-Type': 'text/plain' });
        res.end('ok');
    });
}

const express = require('express')
const app = express()
const session = require('express-session')

app.use(session({
    secret: 'secret',
    cookie: { secure: false } // NOT OK
}))

app.use(session({
    secret: 'secret'
    // NOT OK
}))

app.use(session({
    secret: 'secret',
    cookie: {} // NOT OK
}))

const sess = {
    secret: 'secret',
    cookie: { secure: false } // NOT OK
}

app.use(session(sess))


app.set('trust proxy', 1)
app.use(session({
    secret: 'secret',
    cookie: { secure: true } // OK
}))

const express = require('express')
const app = express()
const session = require('cookie-session')
const expiryDate = new Date(Date.now() + 60 * 60 * 1000)

app.use(session({
    name: 'session',
    keys: ['key1', 'key2'],
    secure: true, // OK
    httpOnly: true,
    domain: 'example.com',
    path: 'foo/bar',
    expires: expiryDate
}))

app.use(session({
    name: 'session',
    keys: ['key1', 'key2'],
    secure: false, // NOT OK
    httpOnly: true,
    domain: 'example.com',
    path: 'foo/bar',
    expires: expiryDate
}))
