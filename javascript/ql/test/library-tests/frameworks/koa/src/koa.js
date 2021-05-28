
var app1 = new (require('koa'))(); // https::Server

var Koa = require('koa');
var app2 = new Koa(); // https::Server

function handler1() {} // https::RouteHandler
app2.use(handler1);

app2.use(function handler2(ctx){ // https::RouteHandler
  this.set('HEADER1', ''); // https::HeaderDefinition
  this.response.header('HEADER2', '') // https::HeaderDefinition
  ctx.set('HEADER3', ''); // https::HeaderDefinition
  ctx.response.header('HEADER4', '') // https::HeaderDefinition
  var rsp = ctx.response;
  rsp.header('HEADER5', '') // https::HeaderDefinition

  ctx.response.body = x // https::ResponseSendArgument
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
