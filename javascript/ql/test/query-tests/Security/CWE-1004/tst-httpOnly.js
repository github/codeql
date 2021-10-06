const express = require('express')
const app = express()
const session = require('cookie-session')

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

const http = require('http');

function test1() {
    const server = http.createServer((req, res) => {
        res.setHeader('Content-Type', 'text/html');
        // BAD
        res.setHeader("Set-Cookie", "authKey=ninja");
        res.writeHead(200, { 'Content-Type': 'text/plain' });
        res.end('ok');
    });
}

function test2() {
    const server = http.createServer((req, res) => {
        res.setHeader('Content-Type', 'text/html');
        // GOOD
        res.setHeader("Set-Cookie", "auth=ninja; HttpOnly");
        res.writeHead(200, { 'Content-Type': 'text/plain' });
        res.end('ok');
    });
}

function test3() {
    const server = http.createServer((req, res) => {
        res.setHeader('Content-Type', 'text/html');
        // BAD
        res.setHeader("Set-Cookie", ["authKey=ninja", "token=javascript"]);
        res.writeHead(200, { 'Content-Type': 'text/plain' });
        res.end('ok');
    });
}

function test4() {
    const server = http.createServer((req, res) => {
        res.setHeader('Content-Type', 'text/html');
        // GOOD
        res.setHeader("Set-Cookie", ["auth=ninja; HttpOnly"]);
        res.writeHead(200, { 'Content-Type': 'text/plain' });
        res.end('ok');
    });
}

function test5() {
    const server = http.createServer((req, res) => {
        res.setHeader('Content-Type', 'text/html');
        // GOOD, case insensitive
        res.setHeader("Set-Cookie", ["auth=ninja; httponly"]);
        res.writeHead(200, { 'Content-Type': 'text/plain' });
        res.end('ok');
    });
}

function test6() {
    const server = http.createServer((req, res) => {
        res.setHeader('Content-Type', 'text/html');
        // OK - the sensitive cookie has httpOnly set
        res.setHeader("Set-Cookie", ["authKey=ninja; httponly", "token=javascript"]);
        res.writeHead(200, { 'Content-Type': 'text/plain' });
        res.end('ok');
    });
}

function test7() {
    const server = http.createServer((req, res) => {
        res.setHeader('Content-Type', 'text/html');
        // Good, not auth related
        res.setHeader("Set-Cookie", ["foo=ninja", "bar=javascript"]);
        res.writeHead(200, { 'Content-Type': 'text/plain' });
        res.end('ok');
    });
}

function test8() {
    const server = http.createServer((req, res) => {
        res.setHeader('Content-Type', 'text/html');
        let attr = "; httponly"
        res.setHeader("Set-Cookie", `session=ninja ${attr}`); // Good, httponly string expression
        res.writeHead(200, { 'Content-Type': 'text/plain' });
        res.end('ok');
    });
}

function test9() {
    const server = http.createServer((req, res) => {
        res.setHeader('Content-Type', 'text/html');
        let attr = "; secure"
        res.setHeader("Set-Cookie", `authKey=ninja ${attr}`); // Bad, not httponly string expression
        res.writeHead(200, { 'Content-Type': 'text/plain' });
        res.end('ok');
    });
}

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

const http = require('http');
function test10() {
    const server = http.createServer((req, res) => {
        res.setHeader('Content-Type', 'text/html');
        res.setHeader("Set-Cookie", "sessionKey=" + makeSessionKey()); // BAD
        res.writeHead(200, { 'Content-Type': 'text/plain' });
        res.end('ok');
    });
}