import * as express from 'express';

interface MyRequest extends express.Request {

}

function t1(req: MyRequest) { // $ MISSING: hasUnderlyingType='express'.Request
}

class MyRequestClass extends express.Request {
}

function t2(req: MyRequestClass) { // $ MISSING: hasUnderlyingType='express'.Request
}

class MyRequestClass2 implements express.Request {
}

function t3(req: MyRequestClass2) { // $ MISSING: hasUnderlyingType='express'.Request
}
