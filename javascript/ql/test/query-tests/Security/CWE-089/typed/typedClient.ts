import * as mongodb from "mongodb";

const express = require('express') as any;
const bodyParser = require('body-parser') as any;

declare function getCollection(): mongodb.Collection;

let app = express();

app.use(bodyParser.json());

app.post('/find', (req, res) => {
  let v = JSON.parse(req.body.x);
  getCollection().find({ id: v }); // NOT OK
});
