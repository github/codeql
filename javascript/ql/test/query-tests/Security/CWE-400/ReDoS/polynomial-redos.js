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
	tainted.replace(/^(`+)([\s\S]*?[^`])\1(?!`)/); // NOT OK
	/^(.*,)+(.+)?$/.test(tainted); // NOT OK
	tainted.match(/[0-9]*['a-z\u00A0-\u05FF\u0700-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]+|[\u0600-\u06FF\/]+(\s*?[\u0600-\u06FF]+){1,2}/i); // NOT OK
	tainted.match(/[0-9]*['a-z\u00A0-\u05FF\u0700-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]{1,256}|[\u0600-\u06FF\/]{1,256}(\s*?[\u0600-\u06FF]{1,256}){1,2}/i); // NOT OK (even though it is a proposed fix for the above)
	tainted.match(/^(\+|-)?(\d+|(\d*\.\d*))?(E|e)?([-+])?(\d+)?$/); // NOT OK
	if (tainted.length < 7000) {
		tainted.match(/^(\+|-)?(\d+|(\d*\.\d*))?(E|e)?([-+])?(\d+)?$/); // OK - but flagged
	}

	tainted.match(/^([a-z0-9-]+)[ \t]+([a-zA-Z0-9+\/ \t\n]+[=]*)(.*)$/); // NOT OK
	tainted.match(/^([a-z0-9-]+)[ \t\n]+([a-zA-Z0-9+\/][a-zA-Z0-9+\/ \t\n=]*)([^a-zA-Z0-9+\/ \t\n=].*)?$/); // OK
	/[a-z][A-Z]|[A-Z]{2,}[a-z]|[0-9][a-zA-Z]|[a-zA-Z][0-9]|[^a-zA-Z0-9 ]/.test(tainted); // NOT OK - but not detected due to not supporting ranges
	/[a-z][A-Z]|[A-Z]{2}[a-z]|[0-9][a-zA-Z]|[a-zA-Z][0-9]|[^a-zA-Z0-9 ]/.test(tainted); // OK

	tainted.replace(/[?]+.*$/g, ""); // OK - can not fail - but still flagged
	tainted.replace(/\-\-+/g, "-").replace(/-+$/, ""); // OK - indirectly sanitized
	tainted.replace(/\n\n\n+/g, "\n").replace(/\n*$/g, "");  // OK - indirectly sanitized
	tainted.match(/(.)*solve\/challenges\/server-side(.)*/); // NOT OK
	tainted.match(/<head>(?![\s\S]*<head>)/i); // OK

	tainted.match(/<.*class="([^"]+)".*>/); // NOT OK
	tainted.match(/<.*style="([^"]+)".*>/); // NOT OK
	tainted.match(/<.*href="([^"]+)".*>/); // NOT OK

	tainted.match(/^([^-]+)-([A-Za-z0-9+/]+(?:=?=?))([?\x21-\x7E]*)$/); // NOT OK
	tainted.match(/^([^-]+)-([A-Za-z0-9+/=]{44,88})(\?[\x21-\x7E]*)*$/); // NOT OK (it is a fix for the above, but it introduces exponential complexity elsewhere)

	tainted.match(/^([a-z0-9-]+)[ \t]+([a-zA-Z0-9+\/]+[=]*)([\n \t]+([^\n]+))?$/); // NOT OK
	tainted.match(/^([a-z0-9-]+)[ \t]+([a-zA-Z0-9+\/]+[=]*)([ \t]+([^ \t][^\n]*[\n]*)?)?$/); // OK

	tainted.match(/^(?:\.?[a-zA-Z_][a-zA-Z_0-9]*)+$/); // NOT OK (also flagged by js/redos)
	tainted.match(/^(?:\.?[a-zA-Z_][a-zA-Z_0-9]*)(?:\.[a-zA-Z_][a-zA-Z_0-9]*)*$/); // OK
	tainted.replaceAll(/\s*\n\s*/g, ' '); // NOT OK

	/Y.*X/.test(tainted); // NOT OK
	/B?(YH|K)(YH|J)*X/.test(tainted) // NOT OK
	(/B?(YH|K).*X/.test(tainted)); // NOT OK
	/(B|Y)+(Y)*X/.test(tainted) // NOT OK
	(/(B|Y)+(.)*X/.test(tainted)) // NOT OK
	(/f(B|Y)+(Y)*X/.test(tainted)); // NOT OK
	/f(B|Y)+(Y)*X/.test(tainted) // NOT OK
	(/f(B|Y)+(Y|K)*X/.test(tainted)) // NOT OK
	(/f(B|Y)+.*X/.test(tainted)) // NOT OK
	(/f(B|Y)+(.)*X/.test(tainted)) // NOT OK
	(/^(.)*X/.test(tainted)); // OK
	(/^Y(Y)*X/.test(tainted)); // OK
	(/^Y*Y*X/.test(tainted)); // NOT OK
	(/^(K|Y)+Y*X/.test(tainted)); // NOT OK
	(/^foo(K|Y)+Y*X/.test(tainted)); // NOT OK
	(/^foo(K|Y)+.*X/.test(tainted)); // NOT OK
	(/(K|Y).*X/.test(tainted)); // NOT OK
	(/[^Y].*X/.test(tainted)); // NOT OK
	(/[^Y].*$/.test(req.url)); // OK - the input cannot contain newlines.
	(/[^Y].*$/.test(req.body)); // NOT OK

	tainted.match(/^([^-]+)-([A-Za-z0-9+/]+(?:=?=?))([?\x21-\x7E]*)$/); // NOT OK

	tainted.match(new RegExp("(MSIE) (\\d+)\\.(\\d+).*XBLWP7")); // NOT OK

	tainted.match(/<.*class="([^"]+)".*>/); // NOT OK

	tainted.match(/Y.*X/); // NOT OK
	tatined.match(/B?(YH|K)(YH|J)*X/); // NOT OK - but not detected

	tainted.match(/a*b/); // NOT OK - the initial repetition can start matching anywhere.
	tainted.match(/cc*D/); // NOT OK
	tainted.match(/^ee*F/); // OK 
	tainted.match(/^g*g*/); // OK
	tainted.match(/^h*i*/); // OK

	tainted.match(/^(ab)*ab(ab)*X/); // NOT OK

	tainted.match(/aa*X/); // NOT OK
	tainted.match(/^a*a*X/); // NOT OK
	tainted.match(/\wa*X/); // NOT OK
	tainted.match(/a*b*c*/); // OK
	tainted.match(/a*a*a*a*/); // OK

	tainted.match(/^([3-7]|A)*([2-5]|B)*X/); // NOT OK
	tainted.match(/^\d*([2-5]|B)*X/); // NOT OK
	tainted.match(/^([3-7]|A)*\d*X/); // NOT OK

	tainted.match(/^(ab)+ab(ab)+X/); // NOT OK

	tainted.match(/aa+X/); // NOT OK
	tainted.match(/a+X/); // NOT OK
	tainted.match(/^a+a+X/); // NOT OK
	tainted.match(/\wa+X/); // NOT OK
	tainted.match(/a+b+c+/); //NOT  OK
	tainted.match(/a+a+a+a+/); // OK

	tainted.match(/^([3-7]|A)+([2-5]|B)+X/); // NOT OK
	tainted.match(/^\d+([2-5]|B)+X/); // NOT OK
	tainted.match(/^([3-7]|A)+\d+X/); // NOT OK

	tainted.match(/\s*$/); // NOT OK
	tainted.match(/\s+$/); // NOT OK

	tainted.match(/^\d*5\w*$/); // NOT OK

	tainted.match(/\/\*[\d\D]*?\*\//g); // NOT OK

	tainted.match(/(#\d+)+/); // OK - but still flagged due to insufficient suffix-checking.

	(function foo() {
		var replaced = tainted.replace(/[^\w\s\-\.\_~]/g, '');
		var result = ""
		result += replaced;
		result = result.replace(/^\s+|\s+$/g, ''); // NOT OK
	})();

	tainted.match(/(https?:\/\/[^\s]+)/gm); // OK

	var modified = tainted.replace(/a/g, "b");
	modified.replace(/cc+D/g, "b"); // NOT OK
	
	var modified2 = tainted.replace(/a|b|c|\d/g, "e");
	modified2.replace(/ff+G/g, "b"); // NOT OK

    var modified3 = tainted.replace(/\s+/g, "");
    modified3.replace(/hh+I/g, "b"); // NOT OK

    tainted.match(/(AA|BB)(AA|BB)(AA|BB)(AA|BB)(AA|BB)(AA|BB)(AA|BB)(AA|BB)(AA|BB)(AA|BB)(AA|BB)(AA|BB)(AA|BB)(AA|BB)(AA|BB)(AA|BB)(AA|BB)(AA|BB)(AA|BB)(AA|BB)(AA|BB)(AA|BB)(AA|BB)(AA|BB)(AA|BB)(AA|BB)(AA|BB)(AA|BB)(AA|BB)(AA|BB)(AA|BB)(AA|BB)(AA|BB)(AA|BB)(AA|BB)(AA|BB)(AA|BB)(AA|BB)(AA|BB)(AA|BB)(AA|BB)(AA|BB)(AA|BB)C.*X/); // NOT OK
	
	modified3.replace(new RegExp("hh+I", "g"), "b"); // NOT OK
	modified3.replace(new RegExp("hh+I", unknownFlags()), "b"); // NOT OK
	modified3.replace(new RegExp("hh+I", ""), "b"); // NOT OK
});
