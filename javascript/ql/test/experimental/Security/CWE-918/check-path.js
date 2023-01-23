// native modules
const path = require('path');
const url = require('url');

// dependencies
const axios = require('axios');
const express = require('express');

// constants
const VALID_PATHS = ['/api/users/me', '/help', '/system/health'];

// start
const app = express();

app.get('/check-with-axios', req => {
  const hardcoded = 'hardcodeado';

  axios.get('test.com/' + hardcoded); // OK
  axios.get('test.com/' + req.query.tainted); // SSRF
  axios.get('test.com/' + Number(req.query.tainted)); // OK
  axios.get('test.com/' + req.user.id); // OK
  axios.get('test.com/' + encodeURIComponent(req.query.tainted)); // OK
  axios.get(`/addresses/${req.query.tainted}`); // SSRF
  axios.get(`/addresses/${encodeURIComponent(req.query.tainted)}`); // OK
  
  if (Number.isInteger(req.query.tainted)) {
    axios.get('test.com/' + req.query.tainted); // OK
  }

  if (isValidInput(req.query.tainted)){
    axios.get('test.com/' + req.query.tainted); // OK
  } else {
    axios.get('test.com/' + req.query.tainted); // SSRF
  }

  if (doesntCheckAnything(req.query.tainted)) {
    axios.get('test.com/' + req.query.tainted); // SSRF
  }

  if (isValidPath(req.query.tainted, VALID_PATHS)) {
    axios.get('test.com/' + req.query.tainted) // OK
  }

  let baseURL = require('config').base
  axios.get(`${baseURL}${req.query.tainted}`); // SSRF

  if(!isValidInput(req.query.tainted)) {
    return;
  }
  axios.get("test.com/" + req.query.tainted); // OK
});

const isValidPath = (path, validPaths) => validPaths.includes(path);

const isValidInput = (path) => Number.isInteger(path);

const doesntCheckAnything = (path) => true;
