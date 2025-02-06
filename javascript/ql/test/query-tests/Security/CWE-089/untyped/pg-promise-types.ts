import { IDatabase } from "pg-promise";

export class Foo {
  db: IDatabase;

  onRequest(req, res) {
    let taint = req.params.x;
    this.db.one(taint); // $ Alert
    res.end();
  }
}

require('express')().get('/foo', (req, res) => new Foo().onRequest(req, res));
