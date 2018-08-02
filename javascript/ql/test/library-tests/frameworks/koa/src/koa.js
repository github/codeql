
var app1 = new (require('koa'))(); // HTTP::Server

var Koa = require('koa');
var app2 = new Koa(); // HTTP::Server

function handler1() {} // HTTP::RouteHandler
app2.use(handler1);

app2.use(function handler2(ctx){ // HTTP::RouteHandler
  this.set('HEADER1', ''); // HTTP::HeaderDefinition
  this.response.header('HEADER2', '') // HTTP::HeaderDefinition
  ctx.set('HEADER3', ''); // HTTP::HeaderDefinition
  ctx.response.header('HEADER4', '') // HTTP::HeaderDefinition
  var rsp = ctx.response;
  rsp.header('HEADER5', '') // HTTP::HeaderDefinition

  ctx.response.body = x // HTTP::ResponseSendArgument
  ctx.request.body;
  ctx.request.query.foo;
  ctx.request.url;
  ctx.request.originalUrl;
  ctx.request.href;
  ctx.request.header.bar;
  ctx.request.headers.bar;
  ctx.request.get('bar');
  ctx.cookies.get('baz');
});
