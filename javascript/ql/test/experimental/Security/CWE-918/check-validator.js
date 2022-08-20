// dependencies
const axios = require('axios');
const express = require('express');
const validator = require('validator');

// start
const app = express();

app.get("/check-with-axios", req => {
  // alphanumeric
  if (validator.isAlphanumeric(req.query.tainted)) {
    axios.get("test.com/" + req.query.tainted); // OK
  }
  if (isAlphanumeric(req.query.tainted)) {
    axios.get("test.com/" + req.query.tainted); // SSRF
  }
  if (validAlphanumeric(req.query.tainted)) {
    axios.get("test.com/" + req.query.tainted); // OK
  }
  if (validAlpha(req.query.tainted)) {
    axios.get("test.com/" + req.query.tainted); // OK
  }
  if (validNumber(req.query.tainted)) {
    axios.get("test.com/" + req.query.tainted); // OK
  }
  if (wrongValidation(req.query.tainted)) {
    axios.get("test.com/" + req.query.tainted); // SSRF
  }

  // numbers
  if (validHexadecimal(req.query.tainted)) {
    axios.get("test.com/" + req.query.tainted); // OK
  }
  if (validHexaColor(req.query.tainted)) {
    axios.get("test.com/" + req.query.tainted); // OK
  }
  if (validDecimal(req.query.tainted)) {
    axios.get("test.com/" + req.query.tainted); // OK
  }
  if (validFloat(req.query.tainted)) {
    axios.get("test.com/" + req.query.tainted); // OK
  }
  if (validInt(req.query.tainted)) {
    axios.get("test.com/" + req.query.tainted); // OK
  }
  if (validOctal(req.query.tainted)) {
    axios.get("test.com/" + req.query.tainted); // OK
  }
  if (validHexa(req.query.tainted)) {
    axios.get("test.com/" + req.query.tainted); // OK. False Positive
  }

  // with simple assignation
  const numberURL = req.query.tainted;
  if (validNumber(numberURL)) {
    axios.get("test.com/" + numberURL); // OK
  }
  if (validNumber(numberURL)) {
    axios.get("test.com/" + req.query.tainted); // OK. False Positive
  }
  if (validNumber(req.query.tainted)) {
    axios.get("test.com/" + numberURL); // OK. False Positive
  }

  if (validHexadecimal(req.query.tainted) || validHexaColor(req.query.tainted) || 
      validDecimal(req.query.tainted) || validFloat(req.query.tainted) || validInt(req.query.tainted) || 
      validNumber(req.query.tainted) || validOctal(req.query.tainted)) {
    axios.get("test.com/" + req.query.tainted); // OK. False Positive
  }
});

// safe validators
const validAlphanumeric = url => validator.isAlphanumeric(url);

const validAlpha = url => validator.isAlpha(url);

const validDecimal = url => validator.isDecimal(url);

const validFloat = url => validator.isFloat(url);

const validInt = url => validator.isInt(url);

const validNumber = url => validator.isNumeric(url);

const validOctal = url => validator.isOctal(url);

const validHexa = url => validator.isHexadecimal(url) || validator.isHexColor(url);

const validHexadecimal = url => validator.isHexadecimal(url);

const validHexaColor = url => validator.isHexColor(url);

const validUUID = url => validator.isUUID(url);

// unsafe validators
const wrongValidation = url => validator.isByteLength(url, {min:4,max:8});

const isAlphanumeric = url => true;
