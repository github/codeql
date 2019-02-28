let _ = require('lodash');
let fs = require('fs');
let express = require('express');

let app = express();

app.get('/template', (req, res) => {
  _.template('<h1><%= title %></h1>', { title: req.query.title });
});
