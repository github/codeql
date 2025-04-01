import * as express from 'express';

interface Options {
    handle(req: express.Request): void; // $ hasUnderlyingType='express'.Request
}

declare function doSomething(options: Options);

function t1() {
    doSomething({
        handle(req) { // $ MISSING: hasUnderlyingType='express'.Request
        }
    });
}

function t2(callback: ((opts: Options) => void) | undefined) {
    callback({
        handle(req) { } // $ MISSING: hasUnderlyingType='express'.Request
    })
    callback!({
        handle(req) { } // $ MISSING: hasUnderlyingType='express'.Request
    })
}

function t3(): Options {
    return {
        handle(req) { } // $ MISSING: hasUnderlyingType='express'.Request
    }
}
