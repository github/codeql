var express = require('express');
var Koa = require('koa');

express().get('/some/path', function(req, res) {
    var foo = req.query.foo;
    foo.indexOf(); // NOT OK

    foo.concat(); // NOT OK

    function f() {
        foo.concat(); // NOT OK
    }

    function g(bar) {
        bar.concat(); // NOT OK
    }
    g(foo);

    req.url.indexOf(); // OK

    foo.indexOf(prefix) === 0; // OK
    foo.indexOf(prefix) == 0; // OK
    foo.indexOf(prefix) !== 0; // OK

    foo.slice(-1) === 'x'; // OK

    foo.indexOf(prefix) == 1; // NOT OK
    foo.slice(1) === 'x'; // NOT OK

    if (typeof foo === "string") {
        foo.indexOf(); //  OK
    } else {
        foo.indexOf(); //  OK
    }
    if (foo instanceof Array) {
        foo.indexOf(); //  OK, but still flagged [INCONSISTENCY]
    }

    (foo + f()).indexOf(); // OK

    foo.length; // NOT OK
});

new Koa().use(function handler(ctx){
    var foo = ctx.request.query.foo;
    foo.indexOf(); // NOT OK
});

express().get('/some/path/:foo', function(req, res) {
    var foo = req.params.foo;
    foo.indexOf(); // OK
});

express().get('/some/path/:foo', function(req, res) {
    if (req.query.path.length) {} // OK
    req.query.path.length == 0; // OK
    !req.query.path.length; // OK
    req.query.path.length > 0; // OK
});

express().get('/some/path/:foo', function(req, res) {
    let p = req.query.path;

    if (typeof p !== 'string') {
      return;
    }

    while (p.length) { // OK
      p = p.substr(1);
    }

    p.length < 1; // OK
});

express().get('/some/path/:foo', function(req, res) {
    let someObject = {};
    safeGet(someObject, req.query.path).bar = 'baz'; // prototype pollution here - but flagged in `safeGet`
});

function safeGet(obj, p) {
    if (p === '__proto__' || // NOT OK - could be singleton array
        p === 'constructor') { // NOT OK - could be singleton array
        return null;
    }
    return obj[p];
}
