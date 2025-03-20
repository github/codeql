import * as express from 'express';

function getRequest(): express.Request { }

function t1() {
    getRequest(); // $ MISSING: hasUnderlyingType='express'.Request
}

declare function getRequestAmbient(): express.Request;

function t2() {
    getRequestAmbient(); // $ MISSING: hasUnderlyingType='express'.Request
}

class C {
    method(): express.Request { }
}

function t3(c: C) {
    c.method(); // $ MISSING: hasUnderlyingType='express'.Request
    new C().method(); // $ MISSING: hasUnderlyingType='express'.Request
}

function callback(fn: (req: express.Request) => void) { // $ SPURIOUS: hasUnderlyingType='express'.Request - req seems to be a SourceNode
}

function t4() {
    callback(function (
        req // $ MISSING: hasUnderlyingType='express'.Request
    ) { }
    );
}
