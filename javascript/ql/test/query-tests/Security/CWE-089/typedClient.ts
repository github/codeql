import * as mongodb from "mongodb";

import express from 'express';
import bodyParser from 'body-parser';

declare function getCollection(): mongodb.Collection;

let app = express();

app.use(bodyParser.json());

app.post('/find', (req, res) => {
  let v = JSON.parse(req.body.x);
  getCollection().find({ id: v }); // NOT OK
});
