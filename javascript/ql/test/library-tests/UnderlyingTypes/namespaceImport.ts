import * as express from 'express';

function t1(e: typeof express) { // $ MISSING: hasUnderlyingType='express'
}

function t2(req: express.Request) { // $ hasUnderlyingType='express'.Request
}

function t3(req: Request) { // $ SPURIOUS: hasUnderlyingType=Body hasUnderlyingType=Request - none, not in scope
}

type E = typeof express;

function t4(e: E) { // $ MISSING: hasUnderlyingType='express'
}
