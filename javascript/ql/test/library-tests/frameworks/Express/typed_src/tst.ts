/// <reference path="./shim.d.ts"/>

import * as express from 'express';

function test(x: express.Request) {
  x.body;
}
