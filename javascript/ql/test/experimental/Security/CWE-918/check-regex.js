// dependencies
const axios = require('axios');
const express = require('express');

// start
const app = express();

app.get('/check-with-axios', req => {
  if (req.query.tainted.match(/^[0-9a-z]+$/)) { // letters and numbers
    axios.get("test.com/" + req.query.tainted); // OK
  }
  if (req.query.tainted.match(/^[0-9a-z\-_]+$/)) { // letters, numbers, - and _
    axios.get("test.com/" + req.query.tainted); // OK
  }
  if (req.query.tainted.match(/^.*$/)) { // anything
    axios.get("test.com/" + req.query.tainted); // SSRF - False Negative
  }

  const baseURL = "test.com/"
  if (isValidPath(req.params.tainted) ) {
    axios.get(baseURL + req.params.tainted); // OK
  }
  if (!isValidPath(req.params.tainted) ) {
    axios.get(baseURL + req.params.tainted); // SSRF
  } else {
    axios.get(baseURL + req.params.tainted); // OK
  }
  
  // Blacklists are not safe
  if (!req.query.tainted.match(/^[/\.%]+$/)) {
    axios.get("test.com/" + req.query.tainted); // SSRF
  }
  if (!isInBlacklist(req.params.tainted) ) {
    axios.get(baseURL + req.params.tainted); // SSRF
  }

  if (!isValidPath(req.params.tainted)) {
    return;
  }

  axios.get("test.com/" + req.query.tainted); // OK - False Positive
});

const isValidPath = path =>  path.match(/^[0-9a-z]+$/);

const isInBlackList = path =>  path.match(/^[/\.%]+$/);
