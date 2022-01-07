const serverless = require("serverless-http");
const express = require("express");
const app = express();

app.get("/", (req, res, next) => {
  res.send("Hello " + req.query.name);
});

module.exports.handler = serverless(app);
