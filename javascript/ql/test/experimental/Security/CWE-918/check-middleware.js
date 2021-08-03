// dependencies
const axios = require('axios');
const express = require('express');

// start
const app = express();

app.get('/check-with-axios', validationMiddleware, req => {
  axios.get("test.com/" + req.query.tainted); // OK is sanitized by the middleware - False Positive
});


const validationMiddleware = (req, res, next) => {
  if (!Number.isInteger(req.query.tainted)) {
    return res.sendStatus(400);
  }

  next();
}
