var express = require('express');
var Koa = require('koa');

express().get('/some/path', function (req, res) {
    var foo = req.query.foo; // $ Source
    foo.indexOf(); // $ Alert

    foo.concat(); // $ Alert

    function f() {
        foo.concat(); // $ Alert
    }

    function g(bar) {
        bar.concat(); // $ Alert
    }
    g(foo);

    req.url.indexOf();

    foo.indexOf(prefix) === 0;
    foo.indexOf(prefix) == 0;
    foo.indexOf(prefix) !== 0;

    foo.slice(-1) === 'x';

    foo.indexOf(prefix) == 1; // $ Alert
    foo.slice(1) === 'x'; // $ Alert

    foo.length; // $ Alert

    if (typeof foo === "string") {
        foo.indexOf();
    } else {
        foo.indexOf();
    }
    if (foo instanceof Array) {
        foo.indexOf();
    }

    (foo + f()).indexOf();

    foo.length; // $ MISSING: Alert - missed due to guards sanitising both branches
});

new Koa().use(function handler(ctx) {
    var foo = ctx.request.query.foo; // $ Source
    foo.indexOf(); // $ Alert
});

express().get('/some/path/:foo', function (req, res) {
    var foo = req.params.foo;
    foo.indexOf();
});

express().get('/some/path/:foo', function (req, res) {
    if (req.query.path.length) { }
    req.query.path.length == 0;
    !req.query.path.length;
    req.query.path.length > 0;
});

express().get('/some/path/:foo', function (req, res) {
    let p = req.query.path;

    if (typeof p !== 'string') {
        return;
    }

    while (p.length) {
        p = p.substr(1);
    }

    p.length < 1;
});

express().get('/some/path/:foo', function (req, res) {
    let someObject = {};
    safeGet(someObject, req.query.path).bar = 'baz'; // $ Source - prototype pollution here - but flagged in `safeGet`
});

function safeGet(obj, p) {
    if (p === '__proto__' || // $ Alert - could be singleton array
        p === 'constructor') { // $ Alert - could be singleton array
        return null;
    }
    return obj[p];
}

express().get('/foo', function (req, res) {
    let data = req.query;
    data.foo.indexOf(); // $ Alert
    if (typeof data.foo !== 'undefined') {
        data.foo.indexOf(); // $ Alert
    }
    if (typeof data.foo !== 'string') {
        data.foo.indexOf();
    }
    if (typeof data.foo !== 'undefined') {
        data.foo.indexOf(); // $ Alert
    }
});

express().get('/foo', function (req, res) {
    let data = req.query.data; // $ Source
    data.indexOf(); // $ Alert
    if (Array.isArray(data)) {
        data.indexOf();
    } else {
        data.indexOf();
    }
});
