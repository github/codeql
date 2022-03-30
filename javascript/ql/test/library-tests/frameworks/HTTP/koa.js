const Koa = require('koa');

const app = module.exports = new Koa();

app.use(function(ctx) {
    ctx.request.query.p1;
    ctx.request.body;
    ctx.request.url;
    ctx.request.originalUrl;
    ctx.request.href;
    ctx.request.header.p2;
    ctx.request.headers.p3;
    ctx.request.get();
    ctx.cookies.get();
});
