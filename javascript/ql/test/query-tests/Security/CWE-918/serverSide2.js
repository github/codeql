const express = require('express');
const axios = require('axios');
const qs = require('qs');

const app = express();
const PORT = 3000;

app.use((req, res, next) => {
  req.parsedQueryFromParsedUrl = qs.parse(req._parsedUrl.query);  // $Source[js/request-forgery]
  req.parsedQuery.url = req.url || {}; // $Source[js/request-forgery]
  req.SomeObject.url = req.url; // $Source[js/request-forgery]
  next();
});

app.get('/proxy', async (req, res) => {
    const targetUrl = req.parsedQuery.url;  
    const response = await axios.get(targetUrl); // $Alert[js/request-forgery]

    const targetUrl1 = req.parsedQueryFromParsedUrl.url;  
    const response1 = await axios.get(targetUrl1); // $Alert[js/request-forgery]
 
    const targetUrl2 = req.url || {};  // $Source[js/request-forgery]
    const response2 = await axios.get(targetUrl2);  // $Alert[js/request-forgery]

    const targetUrl3 = req.SomeObject.url || {};
    const response3 = await axios.get(targetUrl3);  // $Alert[js/request-forgery]
});
