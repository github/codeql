const Koa = require('koa');
const urlLib = require('url');
const app = new Koa();

app.use(async ctx => {
	var url = ctx.query.target; // $ Source
	ctx.redirect(url); // $ Alert
	ctx.redirect(`${url}${x}`); // $ Alert

	var isCrossDomainRedirect = urlLib.parse(url || '', false, true).hostname;
	if(!url || isCrossDomainRedirect) {
		ctx.redirect('/');
	} else {
		ctx.redirect(url); // $ Alert
	}

	if(!url || isCrossDomainRedirect || url.match(VALID)) {
		ctx.redirect('/');
	} else {
		ctx.redirect(url); // $ Alert - possibly OK but flagged anyway
	}

	if(!url || isCrossDomainRedirect || url.match(/[^\w/-]/)) {
		ctx.redirect('/');
	} else {
		ctx.redirect(url);
	}
});

app.listen(3000);
