import * as express from 'express';

function t1(e) {
    var req: express.Request = e; // $ MISSING: hasUnderlyingType='express'.Request
}
