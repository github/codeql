const express = require('express')
const app = express()
const session = require('cookie-session')

app.use(session({
    name: 'session',
    keys: ['key1', 'key2'],
    httpOnly: true,
}))

app.use(session({
    name: 'session',
    keys: ['key1', 'key2'],
    httpOnly: false
})) // $ Alert

app.use(session({
    name: 'session',
    keys: ['key1', 'key2'],
    secure: true // OK - httpOnly is true by default
}))

var sess = {
    name: 'session',
    keys: ['key1', 'key2'],
}

sess.httpOnly = false;
app.use(session(sess)) // $ Alert

var sess2 = {
    name: 'session',
    keys: ['key1', 'key2'],
    httpOnly: true,
}

sess2.httpOnly = false;
app.use(session(sess2)) // $ Alert

var sess3 = {
    name: 'mycookie',
    keys: ['key1', 'key2'],
    httpOnly: true,
}

sess3.httpOnly = false;
app.use(session(sess3)) // $ Alert - It is a session cookie, name doesn't matter

var flag = false
var flag2 = flag
app.use(session({
    name: 'session',
    keys: ['key1', 'key2'],
    httpOnly: flag2
})) // $ Alert

app.get('/a', function (req, res, next) {
    res.cookie('authkey', 'value',
        {
            maxAge: 9000000000,
            httpOnly: true,
            secure: false
        });
    res.end('ok')
})

app.get('/a', function (req, res, next) {
    res.cookie('authkey', 'value',
        {
            maxAge: 9000000000,
            httpOnly: false,
            secure: false
        }); // $ Alert
    res.end('ok')
})

app.get('/a', function (req, res, next) {
    res.cookie('authkey', 'value',
        {
            maxAge: 9000000000
        }); // $ Alert
    res.end('ok')
})

app.get('/a', function (req, res, next) {
    let options = {
        maxAge: 9000000000,
        httpOnly: true,
        secure: false
    }
    res.cookie('authkey', 'value', options);
    res.end('ok')
})

app.get('/a', function (req, res, next) {
    let options = {
        maxAge: 9000000000,
        httpOnly: false,
        secure: false
    }
    res.cookie('authkey', 'value', options); // $ Alert
    res.end('ok')
})

app.get('/a', function (req, res, next) {
    let options = {
        maxAge: 9000000000
    }
    res.cookie('authkey', 'value', options); // $ Alert
    res.end('ok')
})

app.get('/a', function (req, res, next) {
    let options = {
        maxAge: 9000000000
    }
    options.httpOnly = false;
    res.cookie('authkey', 'value', options); // $ Alert
    res.end('ok')
})

app.get('/a', function (req, res, next) {
    let options = {
        maxAge: 9000000000
    }
    options.httpOnly = true;
    res.cookie('authkey', 'value', options);
    res.end('ok')
})

app.get('/a', function (req, res, next) {
    let options = {
        maxAge: 9000000000,
        httpOnly: false,
    }
    options.httpOnly = false;
    res.cookie('authkey', 'value', options); // $ Alert
    res.end('ok')
})

app.get('/a', function (req, res, next) {
    let options = {
        maxAge: 9000000000,
        httpOnly: false,
    }
    options.httpOnly = false;
    let authKey = "blabla"
    res.cookie(authKey, 'value', options); // $ Alert - var name likely auth related
    res.end('ok')
})

app.get('/a', function (req, res, next) {
    let options = {
        maxAge: 9000000000,
        httpOnly: false,
    }
    options.httpOnly = false;
    let o = { authKey: "blabla" }
    res.cookie(o.authKey, 'value', options); // $ Alert - var name likely auth related
    res.end('ok')
})

app.get('/a', function (req, res, next) {
    let options = {
        maxAge: 9000000000,
        httpOnly: false,
    }
    options.httpOnly = false;
    let blabla = "authKey"
    res.cookie(blabla, 'value', options); // $ Alert - var name likely auth related
    res.end('ok')
})

app.get('/a', function (req, res, next) {
    let options = {
        maxAge: 9000000000,
        httpOnly: true,
    }
    options.httpOnly = true;
    res.cookie('authkey', 'value', options);
    res.end('ok')
})

app.get('/a', function (req, res, next) {
    let options = {
        maxAge: 9000000000,
        httpOnly: false,
    }
    options.httpOnly = true;
    res.cookie('authkey', 'value', options);
    res.end('ok')
})

app.get('/a', function (req, res, next) {
    let options = {
        maxAge: 9000000000,
        httpOnly: false,
    }
    res.cookie('mycookie', 'value', options); // OK - name likely is not auth sensitive
    res.end('ok')
})

const http = require('http');

function test1() {
    const server = http.createServer((req, res) => {
        res.setHeader('Content-Type', 'text/html');
        res.setHeader("Set-Cookie", "authKey=ninja"); // $ Alert
        res.writeHead(200, { 'Content-Type': 'text/plain' });
        res.end('ok');
    });
}

function test2() {
    const server = http.createServer((req, res) => {
        res.setHeader('Content-Type', 'text/html');

        res.setHeader("Set-Cookie", "auth=ninja; HttpOnly");
        res.writeHead(200, { 'Content-Type': 'text/plain' });
        res.end('ok');
    });
}

function test3() {
    const server = http.createServer((req, res) => {
        res.setHeader('Content-Type', 'text/html');
        res.setHeader("Set-Cookie", ["authKey=ninja", "token=javascript"]); // $ Alert
        res.writeHead(200, { 'Content-Type': 'text/plain' });
        res.end('ok');
    });
}

function test4() {
    const server = http.createServer((req, res) => {
        res.setHeader('Content-Type', 'text/html');

        res.setHeader("Set-Cookie", ["auth=ninja; HttpOnly"]);
        res.writeHead(200, { 'Content-Type': 'text/plain' });
        res.end('ok');
    });
}

function test5() {
    const server = http.createServer((req, res) => {
        res.setHeader('Content-Type', 'text/html');
        // OK - case insensitive
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
        // OK - not auth related
        res.setHeader("Set-Cookie", ["foo=ninja", "bar=javascript"]);
        res.writeHead(200, { 'Content-Type': 'text/plain' });
        res.end('ok');
    });
}

function test8() {
    const server = http.createServer((req, res) => {
        res.setHeader('Content-Type', 'text/html');
        let attr = "; httponly"
        res.setHeader("Set-Cookie", `session=ninja ${attr}`); // OK - httponly string expression
        res.writeHead(200, { 'Content-Type': 'text/plain' });
        res.end('ok');
    });
}

function test9() {
    const server = http.createServer((req, res) => {
        res.setHeader('Content-Type', 'text/html');
        let attr = "; secure"
        res.setHeader("Set-Cookie", `authKey=ninja ${attr}`); // $ Alert - not httponly string expression
        res.writeHead(200, { 'Content-Type': 'text/plain' });
        res.end('ok');
    });
}

const session = require('express-session')

app.use(session({
    name: 'session',
    keys: ['key1', 'key2'],
    cookie: { httpOnly: true },
}))

app.use(session({
    name: 'session',
    keys: ['key1', 'key2'],
    cookie: { httpOnly: false }
})) // $ Alert

app.use(session({
    name: 'session',
    keys: ['key1', 'key2'],
    cookie: { secure: true } // OK - httpOnly is true by default
}))

app.use(session({ // OK - httpOnly is true by default
    name: 'session',
    keys: ['key1', 'key2']
}))

app.use(session({
    name: 'mycookie',
    keys: ['key1', 'key2'],
    cookie: { httpOnly: false } // It is a session cookie, name doesn't matter
})) // $ Alert

const http = require('http');
function test10() {
    const server = http.createServer((req, res) => {
        res.setHeader('Content-Type', 'text/html');
        res.setHeader("Set-Cookie", "sessionKey=" + makeSessionKey()); // $ Alert
        res.writeHead(200, { 'Content-Type': 'text/plain' });
        res.end('ok');
    });
}