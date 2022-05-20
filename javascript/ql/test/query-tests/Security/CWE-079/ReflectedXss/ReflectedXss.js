var express = require('express');

var app = express();

app.get('/user/:id', function(req, res) {
  if (!isValidUserId(req.params.id)) {
    // BAD: a request parameter is incorporated without validation into the response
    res.send("Unknown user: " + req.params.id);
    moreBadStuff(req.params, res);
  } else {
    // TODO: do something exciting
    ;
  }
});

function moreBadStuff(params, res) {
  res.send("Unknown user: " + params.id); // NOT OK
}

var marked = require("marked");
app.get('/user/:id', function(req, res) {
  res.send(req.body); // NOT OK
  res.send(marked(req.body)); // NOT OK
});


var table = require('markdown-table')
app.get('/user/:id', function(req, res) {
  res.send(req.body); // NOT OK
  var mytable = table([
    ['Name', 'Content'],
    ['body', req.body]
  ]);
  res.send(mytable); // NOT OK
});

var showdown  = require('showdown');
var converter = new showdown.Converter();

app.get('/user/:id', function(req, res) {
  res.send(req.body); // NOT OK
  res.send(converter.makeHtml(req.body)); // NOT OK
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
  res.send(req.body); // NOT OK

  unified()
    .use(markdown)
    .use(remark2rehype)
    .use(doc, { title: '👋🌍' })
    .use(format)
    .use(html)
    .process(req.body, function (err, file) {
      res.send(file); // NOT OK
    });

  res.send(remark().processSync(req.body).toString()); // NOT OK

  res.send(remark().use(sanitize).processSync(req.body).toString()); // OK

  res.send(unified().use(markdown).processSync(req.body).toString); // NOT OK

  remark().process(req.body, (e, f) => {
    res.send(f); // NOT OK
  })
});

import snarkdown from 'snarkdown';
var snarkdown2 = require("snarkdown");

app.get('/user/:id', function (req, res) {
  res.send(req.body); // NOT OK
  res.send(snarkdown(req.body)); // NOT OK
  res.send(snarkdown2(req.body)); // NOT OK
});

const markdownIt = require('markdown-it')({
  html: true
});
const markdownIt2 = require('markdown-it')({});

const markdownIt3 = require('markdown-it')({html: true})
  .use(require('markdown-it-highlightjs'));

app.get('/user/:id', function (req, res) {
  res.send(req.body); // NOT OK
  res.send(markdownIt.render(req.body)); // NOT OK
  res.send(markdownIt2.render(req.body)); // OK - no html
  res.send(markdownIt3.render(req.body)); // NOT OK

  res.send(markdownIt.use(require('markdown-it-sanitizer')).render(req.body)); // OK - HTML is sanitized. 
  res.send(markdownIt.use(require('markdown-it-abbr')).use(unknown).render(req.body)); // NOT OK
});

var Hapi = require('hapi');
var hapi = new Hapi.Server();
hapi.route({
    handler: function (request){
        return request.query.p; // NOT OK
    }});
