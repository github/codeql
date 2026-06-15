import * as express from 'express';

interface Foo {
    req: express.Request;
    e: typeof express;
}

function t1(f: Foo) {
    f.req; // $ hasUnderlyingType='express'.Request
    f.e; // $ hasUnderlyingType='express'

    const {
        req, // $ hasUnderlyingType='express'.Request
        e // $ hasUnderlyingType='express'
    } = f;
}
