var express = require('express');

var app = express();

app.get('/user/:id', function(req, res) {
  if (!isValidUserId(req.params.id)) {
    res.send("Unknown user: " + req.params.id); // $ Alert - a request parameter is incorporated without validation into the response
    moreBadStuff(req.params, res);
  } else {
    // TODO: do something exciting
    ;
  }
});

function moreBadStuff(params, res) {
  res.send("Unknown user: " + params.id); // $ Alert
}

var marked = require("marked");
app.get('/user/:id', function(req, res) {
  res.send(req.body); // $ Alert
  res.send(marked(req.body)); // $ Alert
});


var table = require('markdown-table')
app.get('/user/:id', function(req, res) {
  res.send(req.body); // $ Alert
  var mytable = table([
    ['Name', 'Content'],
    ['body', req.body] // $ Source
  ]);
  res.send(mytable); // $ Alert
});

var showdown  = require('showdown');
var converter = new showdown.Converter();

app.get('/user/:id', function(req, res) {
  res.send(req.body); // $ Alert
  res.send(converter.makeHtml(req.body)); // $ Alert
});

var unified = require('unified');
var markdown = require('remark-parse');
var remark2rehype = require('remark-rehype');
var doc = require('rehype-document');
var format = require('rehype-format');
var html = require('rehype-stringify');
var remark = require("remark");
var sanitize = require("rehype-sanitize");
const { resetExtensions } = require('showdown');

app.get('/user/:id', function (req, res) {
  res.send(req.body); // $ Alert

  unified()
    .use(markdown)
    .use(remark2rehype)
    .use(doc, { title: '👋🌍' })
    .use(format)
    .use(html)
    .process(req.body, function (err, file) { // $ Source
      res.send(file); // $ Alert
    });

  res.send(remark().processSync(req.body).toString()); // $ Alert

  res.send(remark().use(sanitize).processSync(req.body).toString());

  res.send(unified().use(markdown).processSync(req.body).toString); // $ Alert

  remark().process(req.body, (e, f) => { // $ Source
    res.send(f); // $ Alert
  })
});

import snarkdown from 'snarkdown';
var snarkdown2 = require("snarkdown");

app.get('/user/:id', function (req, res) {
  res.send(req.body); // $ Alert
  res.send(snarkdown(req.body)); // $ Alert
  res.send(snarkdown2(req.body)); // $ Alert
});

const markdownIt = require('markdown-it')({
  html: true
});
const markdownIt2 = require('markdown-it')({});

const markdownIt3 = require('markdown-it')({html: true})
  .use(require('markdown-it-highlightjs'));

app.get('/user/:id', function (req, res) {
  res.send(req.body); // $ Alert
  res.send(markdownIt.render(req.body)); // $ Alert
  res.send(markdownIt2.render(req.body)); // OK - no html
  res.send(markdownIt3.render(req.body)); // $ Alert

  res.send(markdownIt.use(require('markdown-it-sanitizer')).render(req.body)); // OK - HTML is sanitized.
  res.send(markdownIt.use(require('markdown-it-abbr')).use(unknown).render(req.body)); // $ Alert
});

var Hapi = require('hapi');
var hapi = new Hapi.Server();
hapi.route({
    handler: function (request){
        return request.query.p; // $ Alert
    }});

app.get("invalid/keys/:id", async (req, res) => {
    const { keys: queryKeys } = req.query; // $ Source
    const paramKeys = req.params;
    const keys = queryKeys || paramKeys?.keys; // $ Source

    const keyArray = typeof keys === 'string' ? [keys] : keys;
    const invalidKeys = keyArray.filter(key => !whitelist.includes(key));

    if (invalidKeys.length) {
        res.status(400).send(`${invalidKeys.join(', ')} not in whitelist`); // $ Alert
        return;
    }
});
