
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

app2.use(async ctx => {
	ctx.body = x;
	ctx.body;
	ctx.query.foo;
	ctx.url;
	ctx.originalUrl;
	ctx.href;
	ctx.header.bar;
	ctx.headers.bar;
	ctx.set('bar');
	ctx.get('bar');

	var url = ctx.query.target;
	ctx.redirect(url);
	ctx.response.redirect(url);
});

app2.use(async ctx => {
	var cookies = ctx.cookies;
	cookies.get();

	var query = ctx.query;
	query.foo;

	var headers = ctx.headers;
	headers.foo;
});

var app3 = Koa();
app3.use(function*(){
	this.request.url;
});
