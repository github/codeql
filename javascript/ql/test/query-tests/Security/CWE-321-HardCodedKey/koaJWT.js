var Koa = require('koa');
var jwt = require('koa-jwt');
var {getSecret} = require('./Config.js');

var app = new Koa();

// Custom 401 handling if you don't want to expose koa-jwt errors to users
app.use(function (ctx, next) {
    return next().catch((err) => {
        if (401 === err.status) {
            ctx.status = 401;
            ctx.body = 'Protected resource, use Authorization header to get access\n';
        } else {
            throw err;
        }
    });
});

// Unprotected middleware
app.use(function (ctx, next) {
    if (ctx.url.match(/^\/public/)) {
        ctx.body = 'unprotected\n';
    } else {
        return next();
    }
});

// Middleware below this line is only reached if JWT token is valid
app.use(jwt({secret: getSecret()}));

// Protected middleware
app.use(function (ctx) {
    if (ctx.url.match(/^\/api/)) {
        ctx.body = 'protected\n';
    }
});

app.listen(3000);