var express = require('express');
var app = express();

app.use(function(req, res) {
	let tainted = req.query.tainted;

	tainted.replace(/^\s+|\s+$/g, ''); // NOT OK
	tainted.split(/ *, */); // NOT OK
	tainted.replace(/\s*\n\s*/g, ' '); // NOT OK
	tainted.split('\n'); // OK
	tainted.replace(/.*[/\\]/, ''); // NOT OK
	tainted.replace(/.*\./, ''); // NOT OK
	tainted.replace(/^.*[/\\]/, ''); // OK
	tainted.replace(/^.*\./, ''); // OK
	tainted.replace(/^(`+)\s*([\s\S]*?[^`])\s*\1(?!`)/); // NOT OK
	tainted.replace(/^(`+)([\s\S]*?[^`])\1(?!`)/); // OK
	/^(.*,)+(.+)?$/.test(tainted); // NOT OK - but only flagged by js/redos
	tainted.match(/[0-9]*['a-z\u00A0-\u05FF\u0700-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]+|[\u0600-\u06FF\/]+(\s*?[\u0600-\u06FF]+){1,2}/i); // NOT OK
	tainted.match(/[0-9]*['a-z\u00A0-\u05FF\u0700-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]{1,256}|[\u0600-\u06FF\/]{1,256}(\s*?[\u0600-\u06FF]{1,256}){1,2}/i); // NOT OK (even though it is a proposed fix for the above)
	tainted.match(/^(\+|-)?(\d+|(\d*\.\d*))?(E|e)?([-+])?(\d+)?$/); // NOT OK
	if (tainted.length < 7000) {
		tainted.match(/^(\+|-)?(\d+|(\d*\.\d*))?(E|e)?([-+])?(\d+)?$/); // OK - but flagged
	}

	tainted.match(/^([a-z0-9-]+)[ \t]+([a-zA-Z0-9+\/ \t\n]+[=]*)(.*)$/); // NOT OK
	tainted.match(/^([a-z0-9-]+)[ \t\n]+([a-zA-Z0-9+\/][a-zA-Z0-9+\/ \t\n=]*)([^a-zA-Z0-9+\/ \t\n=].*)?$/); // OK
	/[a-z][A-Z]|[A-Z]{2,}[a-z]|[0-9][a-zA-Z]|[a-zA-Z][0-9]|[^a-zA-Z0-9 ]/.test(tainted); // NOT OK
	/[a-z][A-Z]|[A-Z]{2}[a-z]|[0-9][a-zA-Z]|[a-zA-Z][0-9]|[^a-zA-Z0-9 ]/.test(tainted); // OK

	tainted.replace(/[?]+.*$/g, ""); // OK - can not fail - but still flagged
	tainted.replace(/\-\-+/g, "-").replace(/-+$/, ""); // OK - indirectly sanitized
	tainted.replace(/\n\n\n+/g, "\n").replace(/\n*$/g, "");  // OK - indirectly sanitized
	tainted.match(/(.)*solve\/challenges\/server-side(.)*/); // NOT OK
	tainted.match(/<head>(?![\s\S]*<head>)/i); // OK

	tainted.match(/<.*class="([^"]+)".*>/); // NOT OK - but not flagged
	tainted.match(/<.*style="([^"]+)".*>/); // NOT OK - but not flagged
	tainted.match(/<.*href="([^"]+)".*>/); // NOT OK - but not flagged

	tainted.match(/^([^-]+)-([A-Za-z0-9+/]+(?:=?=?))([?\x21-\x7E]*)$/); // NOT OK - but not flagged
	tainted.match(/^([^-]+)-([A-Za-z0-9+/=]{44,88})(\?[\x21-\x7E]*)*$/); // NOT OK (it is a fix for the above, but it introduces exponential complexity elsewhere)

	tainted.match(/^([a-z0-9-]+)[ \t]+([a-zA-Z0-9+\/]+[=]*)([\n \t]+([^\n]+))?$/); // NOT OK - but not flagged due to lack of support for inverted character classes
	tainted.match(/^([a-z0-9-]+)[ \t]+([a-zA-Z0-9+\/]+[=]*)([ \t]+([^ \t][^\n]*[\n]*)?)?$/); // OK

	tainted.match(/^(?:\.?[a-zA-Z_][a-zA-Z_0-9]*)+$/); // NOT OK - but not flagged
	tainted.match(/^(?:\.?[a-zA-Z_][a-zA-Z_0-9]*)(?:\.[a-zA-Z_][a-zA-Z_0-9]*)*$/); // OK
	tainted.replaceAll(/\s*\n\s*/g, ' '); // NOT OK
});
