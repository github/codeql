const express = require('express')
const app = express()

app.get('/a', function (req, res, next) {
    res.cookie('authkey', 'value',
        {
            maxAge: 9000000000,
            httpOnly: true,
            secure: false
        }); // $ Alert
    res.end('ok')
})

app.get('/b', function (req, res, next) {
    let options = {
        maxAge: 9000000000,
        httpOnly: true,
        secure: false
    }
    res.cookie('authKey', 'value', options); // $ Alert
    res.end('ok')
})

app.get('/c', function (req, res, next) {
    res.cookie('name', 'value',
        {
            maxAge: 9000000000,
            httpOnly: true,
            secure: true
        });
    res.end('ok')
})

const js_cookie = require('js-cookie')
js_cookie.set('authKey', 'value', { secure: false }); // $ Alert
js_cookie.set('authKey', 'value', { secure: true });

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

        res.setHeader("Set-Cookie", "type=ninja; Secure");
        res.writeHead(200, { 'Content-Type': 'text/plain' });
        res.end('ok');
    });
}

function test3() {
    const server = http.createServer((req, res) => {
        res.setHeader('Content-Type', 'text/html');
        res.setHeader("Set-Cookie", [
            "authKey=ninja", // $ Alert
            "language=javascript"
            ]);
        res.writeHead(200, { 'Content-Type': 'text/plain' });
        res.end('ok');
    });
}

function test4() {
    const server = http.createServer((req, res) => {
        res.setHeader('Content-Type', 'text/html');

        res.setHeader("Set-Cookie", ["type=ninja; Secure"]);
        res.writeHead(200, { 'Content-Type': 'text/plain' });
        res.end('ok');
    });
}

function test5() {
    const server = http.createServer((req, res) => {
        res.setHeader('Content-Type', 'text/html');
        // OK - case insensitive
        res.setHeader("Set-Cookie", ["type=ninja; secure"]);
        res.writeHead(200, { 'Content-Type': 'text/plain' });
        res.end('ok');
    });
}

function test6() {
    const server = http.createServer((req, res) => {
        res.setHeader('Content-Type', 'text/html');
        res.setHeader("Set-Cookie", [
            "type=ninja; secure",
            "authKey=foo" // $ Alert
        ]);
        res.writeHead(200, { 'Content-Type': 'text/plain' });
        res.end('ok');
    });
}

const express = require('express')
const app = express()
const session = require('express-session')

app.use(session({
    secret: 'secret',
    cookie: { secure: false }
})) // $ Alert

app.use(session({
    secret: 'secret'
})) // $ Alert

app.use(session({
    secret: 'secret',
    cookie: {}
})) // $ Alert

const sess = {
    secret: 'secret',
    cookie: { secure: false }
}

app.use(session(sess)) // $ Alert


app.set('trust proxy', 1)
app.use(session({
    secret: 'secret',
    cookie: { secure: true }
}))

const express = require('express')
const app = express()
const session = require('cookie-session')
const expiryDate = new Date(Date.now() + 60 * 60 * 1000)

app.use(session({
    name: 'session',
    keys: ['key1', 'key2'],
    secure: true,
    httpOnly: true,
    domain: 'example.com',
    path: 'foo/bar',
    expires: expiryDate
}))

app.use(session({
    name: 'session',
    keys: ['key1', 'key2'],
    secure: false,
    httpOnly: true,
    domain: 'example.com',
    path: 'foo/bar',
    expires: expiryDate
})) // $ Alert

http.createServer((req, res) => {
    res.setHeader('Content-Type', 'text/html');
    res.setHeader("Set-Cookie", `authKey=${makeAuthkey()}`); // $ Alert
    res.writeHead(200, { 'Content-Type': 'text/plain' });
    res.end('ok');
});

http.createServer((req, res) => {
    res.setHeader("Set-Cookie", `authKey=${makeAuthkey()}; secure; httpOnly`);
    res.writeHead(200, { 'Content-Type': 'text/html' });
    res.end('<h2>Hello world</h2>');
});

function clientCookies() {
    document.cookie = `authKey=${makeAuthkey()}; secure`;
    document.cookie = `authKey=${makeAuthkey()}`; // $ Alert

    var cookies = require('browser-cookies');
    
    cookies.set('authKey', makeAuthkey()); // $ Alert
    cookies.set('authKey', makeAuthkey(), { secure: true, expires: 7 });

    const cookie = require('cookie');

    cookie.serialize('authKey', makeAuthkey()); // $ Alert
    cookie.serialize('authKey', makeAuthkey(), { secure: true, expires: 7 });
}

const cookie = require('cookie');

http.createServer((req, res) => {
    res.setHeader('Content-Type', 'text/html');
    res.setHeader("Set-Cookie", cookie.serialize("authKey", makeAuthkey(), {secure: true,httpOnly: true}));
    res.setHeader("Set-Cookie", cookie.serialize("authKey", makeAuthkey())); // $ Alert
    res.writeHead(200, { 'Content-Type': 'text/plain' });
    res.end('ok');
});

(function mightBeSecures() {
    const express = require('express')
    const app = express()
    const session = require('express-session')

    app.use(session({
      secret: config.sessionSecret,
      cookie: {
        httpOnly: config.sessionCookie.httpOnly,
        secure: config.sessionCookie.secure && config.secure.ssl
      },
      name: config.sessionKey
    }));
})();