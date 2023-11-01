/// <reference path="./shim.d.ts"/>

import * as express from 'express';

function test(x: express.Request, res: express.Response) {
  x.body;
  res.status(404);
}
