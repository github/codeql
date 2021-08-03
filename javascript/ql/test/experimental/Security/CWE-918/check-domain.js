// native modules
const url = require('url');

// dependencies
const axios = require('axios');
const express = require('express');

// constants
const VALID_DOMAINS = ['example.com', 'example-2.com'];

// start
const app = express();

app.get('/check-with-axios', req => {
  // without validation
  const url = req.query.url;
  axios.get(url); //SSRF

  // validating domain only
  const decodedURI = decodeURIComponent(req.query.url);
  const { hostname } = url.parse(decodedURI);

  const { hostname } = url.parse(decodedURI);

  if (isValidDomain(hostname, validDomains)) {
    axios.get(req.query.url); //SSRF
  }
});

const isValidDomain = (hostname, validDomains) => (
  validDomains.some(domain => (
    hostname === domain || hostname.endsWith(`.${domain}`))
  )
);