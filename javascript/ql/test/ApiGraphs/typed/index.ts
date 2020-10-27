import * as mongodb from "mongodb";

const express = require("express") as any;
const bodyParser = require("body-parser") as any;

declare function getCollection(): mongodb.Collection;

let app = express();

app.use(bodyParser.json());

app.post("/find", (req, res) => {
  let v = JSON.parse(req.body.x);
  getCollection().find({ id: v }); /* use (member find (instance (member Collection (member exports (module mongodb))))) */
});

import * as mongoose from "mongoose";
declare function getMongooseModel(): mongoose.Model;
declare function getMongooseQuery(): mongoose.Query;
app.post("/find", (req, res) => {
  let v = JSON.parse(req.body.x);
  getMongooseModel().find({ id: v }); /* def (parameter 0 (member find (instance (member Model (member exports (module mongoose)))))) */
  getMongooseQuery().find({ id: v }); /* def (parameter 0 (member find (instance (member Query (member exports (module mongoose)))))) */
});
