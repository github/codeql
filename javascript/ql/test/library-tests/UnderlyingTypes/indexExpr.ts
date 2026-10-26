import * as express from 'express';

interface I {
    [s: string]: express.Request;
}
function t1(obj: I, x: string) {
    obj[x]; // $ hasUnderlyingType='express'.Request
}
