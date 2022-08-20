import * as mongodb from "mongodb";

const express = require("express") as any;
const bodyParser = require("body-parser") as any;

declare function getCollection(): mongodb.Collection;

let app = express();

app.use(bodyParser.json());

app.post("/find", (req, res) => {
  let v = JSON.parse(req.body.x);
  getCollection().find({ id: v }); // NOT OK
});

import * as mongoose from "mongoose";
declare function getMongooseModel(): mongoose.Model;
declare function getMongooseQuery(): mongoose.Query;
app.post("/find", (req, res) => {
  let v = JSON.parse(req.body.x);
  getMongooseModel().find({ id: v }); // NOT OK
  getMongooseQuery().find({ id: v }); // NOT OK
});
