import * as express from 'express';

function t1(e) {
    var req1 = e as express.Request; // $ hasUnderlyingType='express'.Request
    var req2 = <express.Request>e; // $ hasUnderlyingType='express'.Request
    var req3 = e satisfies express.Request; // $ hasUnderlyingType='express'.Request
}
