import * as express from 'express';

function t1(e: typeof express) { // $ hasUnderlyingType='express'
}

function t2(req: express.Request) { // $ hasUnderlyingType='express'.Request
}

function t3(req: Request) { // $ hasUnderlyingType=Request // not in scope, refers to a global
}

type E = typeof express;

function t4(e: E) { // $ hasUnderlyingType='express'
}
