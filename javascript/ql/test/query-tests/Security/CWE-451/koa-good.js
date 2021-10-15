var Koa = require('koa');
var app = new Koa();
app.use(function handler(ctx){
    ctx.set('X-Frame-Options', 'DENY')
});
