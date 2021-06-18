const http = require('http');

function test1() {
    const server = http.createServer((req, res) => {
        res.setHeader('Content-Type', 'text/html');
        // BAD
        res.setHeader("Set-Cookie", "auth=ninja");
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
        res.setHeader("Set-Cookie", ["auth=ninja", "token=javascript"]);
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
        // BAD
        res.setHeader("Set-Cookie", ["auth=ninja; httponly", "token=javascript"]);
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
        res.setHeader("Set-Cookie", `session=ninja ${attr}`); // Bad, not httponly string expression
        res.writeHead(200, { 'Content-Type': 'text/plain' });
        res.end('ok');
    });
}