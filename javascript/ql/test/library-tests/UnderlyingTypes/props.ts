import * as express from 'express';

interface Foo {
    req: express.Request;
    e: typeof express;
}

function t1(f: Foo) {
    f.req; // $ MISSING: hasUnderlyingType='express'.Request
    f.e; // $ MISSING: hasUnderlyingType='express'

    const {
        req, // $ MISSING: hasUnderlyingType='express'.Request
        e // $ MISSING: hasUnderlyingType='express'
    } = f;
}
