import * as mongodb from "mongodb";

const express = require("express") as any;
const bodyParser = require("body-parser") as any;

declare function getCollection(): mongodb.Collection;

let app = express();

app.use(bodyParser.json());

app.post("/find", (req, res) => {
  let v = JSON.parse(req.body.x); // $ Source
  getCollection().find({ id: v }); // $ Alert
});

import * as mongoose from "mongoose";
declare function getMongooseModel(): mongoose.Model;
declare function getMongooseQuery(): mongoose.Query;
app.post("/find", (req, res) => {
  let v = JSON.parse(req.body.x); // $ Source
  getMongooseModel().find({ id: v }); // $ Alert
  getMongooseQuery().find({ id: v }); // $ Alert
});
