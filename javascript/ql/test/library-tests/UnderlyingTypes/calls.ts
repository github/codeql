import * as express from 'express';

function getRequest(): express.Request { }

function t1() {
    getRequest(); // $ hasUnderlyingType='express'.Request
}

declare function getRequestAmbient(): express.Request;

function t2() {
    getRequestAmbient(); // $ hasUnderlyingType='express'.Request
}

class C {
    method(): express.Request { }
}

function t3(c: C) {
    c.method(); // $ hasUnderlyingType='express'.Request
    new C().method(); // $ hasUnderlyingType='express'.Request
}

function callback(fn: (req: express.Request) => void) { // $ SPURIOUS: hasUnderlyingType='express'.Request // req seems to be a SourceNode
}

function t4() {
    callback(function (
        req // $ hasUnderlyingType='express'.Request
    ) { }
    );
}
