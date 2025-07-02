let express = require('express');
var app = express();

function bad1(s) {
  return s.replace("'", ""); // $ Alert[js/incomplete-sanitization]
}

function bad2(s) {
  return s.replace(/'/, ""); // $ Alert[js/incomplete-sanitization]
}

function bad3(s) {
  return s.replace(/'/g, "\\'"); // $ Alert[js/incomplete-sanitization]
}

function bad4(s) {
  return s.replace(/'/g, "\\$&"); // $ Alert[js/incomplete-sanitization]
}

function bad5(s) {
  return s.replace(/['"]/g, "\\$&"); // $ Alert[js/incomplete-sanitization]
}

function bad6(s) {
  return s.replace(/(['"])/g, "\\$1"); // $ Alert[js/incomplete-sanitization]
}

function bad7(s) {
  return s.replace(/('|")/g, "\\$1"); // $ Alert[js/incomplete-sanitization]
}

function bad8(s) {
  return s.replace('|', ''); // $ Alert[js/incomplete-sanitization]
}

function bad9(s) {
  return s.replace(/"/g, "\\\""); // $ Alert[js/incomplete-sanitization]
}

function bad10(s) {
  return s.replace("/", "%2F"); // $ Alert[js/incomplete-sanitization]
}

function bad11(s) {
  return s.replace("%25", "%"); // $ Alert[js/incomplete-sanitization]
}

function bad12(s) {
  return s.replace(`'`, ""); // $ Alert[js/incomplete-sanitization]
}

function bad13(s) {
  return s.replace("'", ``); // $ Alert[js/incomplete-sanitization]
}

function bad14(s) {
  return s.replace(`'`, ``); // $ Alert[js/incomplete-sanitization]
}

function bad15(s) {
  return s.replace("'" + "", ""); // $ Alert[js/incomplete-sanitization]
}

function bad16(s) {
  return s.replace("'", "" + ""); // $ Alert[js/incomplete-sanitization]
}

function bad17(s) {
  return s.replace("'" + "", "" + ""); // $ Alert[js/incomplete-sanitization]
}

function good1(s) {
  while (s.indexOf("'") > 0)
    s = s.replace("'", "");
  return s;
}

function good2(s) {
  while (s.indexOf("'") > 0)
    s = s.replace(/'/, "");
  return s;
}

function good3(s) {
  return s.replace("@user", "id10t");
}

function good4(s) {
  return s.replace(/#/g, "\\d+");
}

function good5(s) {
  return s.replace(/\\/g, "\\\\").replace(/['"]/g, "\\$&");
}

function good6(s) {
  return s.replace(/[\\]/g, '\\\\').replace(/[\"]/g, '\\"');
}

function good7(s) {
  s = s.replace(/[\\]/g, '\\\\');
  return s.replace(/[\"]/g, '\\"');
}

function good8(s) {
  return s.replace(/\W/g, '\\$&');
}

function good9(s) {
  return s.replace(/[^\w\s]/g, '\\$&');
}

function good10(s) {
  s = JSON.stringify(s);  // NB: escapes backslashes
  s = s.slice(1, -1);
  s = s.replace(/\\"/g, '"');
  s = s.replace(/'/g, "\\'");
  return "'" + s + "'";
}

function flowifyComments(s) {
  return s.replace(/#/g, '💩');
}

function good11(s) {
  return s.replace("%d", "42");
}

function goodOrBad12(s) {
	s.replace('[', '').replace(']', '');
	s.replace('(', '').replace(')', '');
	s.replace('{', '').replace('}', '');
	s.replace('<', '').replace('>', ''); // $ Alert[js/incomplete-sanitization]

	s.replace('[', '\\[').replace(']', '\\]'); // $ Alert[js/incomplete-sanitization]
	s.replace('{', '\\{').replace('}', '\\}'); // $ Alert[js/incomplete-sanitization]

	s = s.replace('[', '');
	s = s.replace(']', '');
	s.replace(/{/, '').replace(/}/, ''); // $ Alert[js/incomplete-sanitization] - should have used a string literal if a single replacement was intended
	s.replace(']', '').replace('[', ''); // $ Alert[js/incomplete-sanitization] - probably OK, but still flagged
}

function newlines(s) {
	// motivation for whitelist
	require("child_process").execSync("which emacs").toString().replace("\n", "");

	x.replace("\n", "").replace(x, y); // $ Alert[js/incomplete-sanitization]
	x.replace(x, y).replace("\n", ""); // $ Alert[js/incomplete-sanitization]
}

app.get('/some/path', function(req, res) {
  let untrusted = req.param("p");

  // the query doesn't currently check whether untrusted input flows into the
  // sanitiser, but we add these calls anyway to make the tests more realistic

  bad1(untrusted);
  bad2(untrusted);
  bad3(untrusted);
  bad4(untrusted);
  bad5(untrusted);
  bad6(untrusted);
  bad7(untrusted);
  bad8(untrusted);
  bad9(untrusted);
  bad10(untrusted);
  bad11(untrusted);
  bad12(untrusted);
  bad13(untrusted);
  bad14(untrusted);
  bad15(untrusted);
  bad16(untrusted);
  bad17(untrusted);

  good1(untrusted);
  good2(untrusted);
  good3(untrusted);
  good4(untrusted);
  good5(untrusted);
  good6(untrusted);
  good7(untrusted);
  good8(untrusted);
  good9(untrusted);
  good10(untrusted);
  flowifyComments(untrusted);
  good11(untrusted);
  good12(untrusted);
});

(function (s) {
	var indirect = /'/;
	return s.replace(indirect, ""); // $ Alert[js/incomplete-sanitization]
});

(function (s) {
	s.replace('"', '').replace('"', '');
	s.replace("'", "").replace("'", "");
});

function bad18(p) {
  return p.replace("/../", ""); // $ Alert[js/incomplete-sanitization]
}

function typicalBadHtmlSanitizers(s) {
	s().replace(/[<>]/g,'');
	s().replace(/[<>&]/g, '');
	s().replace(/[<>"]/g, '');
	s().replace(/</g, '').replace(/>/g, '');
	s().replace(/</g, '').replace(/>/g, '').replace(/&/g, '');
	s().replace(/</g, '').replace(/&/g, '').replace(/>/g, '');
	s().replace(/&/g, '').replace(/>/g, '').replace(/</g, '');

	var s = s().replace(/</g, '');
	s = s.replace(/>/g, '');
	s().replace(/</g, '&lt;').replace(/>/g, '&gt').replace(/&/g, '&amp;').replace(/"/g, '&#34;');
	s().replace(/</g, '&lt;').replace(/>/g, '&gt').replace(/&/g, '&amp;').replace(/'/g, '&#39;'); // OK - single quotes or double quotes both work

	s().replace(/</g, '&lt;').replace(/>/g, '&gt').replace(RE, function(match) {/* ... */ }); // OK - probably

	s().replace(/[<>'"&]/g,'');

	s().replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;').replace(/&(?![\w\#]+;)/g, '&amp;');

	s().replace(!encode ? /&(?!#?\w+;)/g : /&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;').replace(/'/g, '&apos;'); // OK - and not recognized due to the ternary

	s().replace(/[\\/:\*\?"<>\|]/g, '');

	s().replace(/[<>]/g,'_'); // OK - but probably unsafe

	s().replace(/&/g, "&gt;");

	s().replace(/[\#\%4\/\-\~\>8\_\@0\!\&3\[651d\=e7fA2D\(aFBb]/g, "");

	s().replace(/[<>]/g,'').replace(/[^a-z]/g, '');

	s().replace(/[<>]/g,'').replace(/[^abc]/g, '');

	s().replace(/[<>]/g,'').replace(/[ -~]/g, '');
}

function incompleteHtmlAttributeSanitization() {
	'="' + s().replace(/[<>]/g,'') + '"'; // $ Alert[js/incomplete-html-attribute-sanitization]
	'="' + s().replace(/[<>&]/g, '') + '"'; // $ Alert[js/incomplete-html-attribute-sanitization]
	'="' + s().replace(/[<>"]/g, '') + '"'; // OK - maybe, since the attribute name is unknown
	'="' + s().replace(/[<>&"]/g,'') + '"';
	'="' + s().replace(/[&"]/g,'') + '"';

	'="' + s().replace(/[<>&']/g,'') + '"'; // $ Alert[js/incomplete-html-attribute-sanitization]
	"='" + s().replace(/[<>&"]/g,'') + "'"; // $ Alert[js/incomplete-html-attribute-sanitization]
	"='" + s().replace(/[<>&']/g,'') + "'";

	'onFunkyEvent="' + s().replace(/[<>"]/g, '') + '"'; // $ Alert[js/incomplete-html-attribute-sanitization]
	'<div noise onFunkyEvent="' + s().replace(/[<>"]/g, '') + '"'; // $ Alert[js/incomplete-html-attribute-sanitization]
	'<div noise monday="' + s().replace(/[<>"]/g, '') + '"';
	'monday="' + s().replace(/[<>"]/g, '') + '"';
}

function multiStepSanitization() {
	function escapeHTML(value) {
		return value.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;');
	}
	function attr_str(a) {
		return ' ' + a.name + '="' + escapeHTML(a.value).replace(/"/g, '&quot;') + '"';
	}
	result += '<' + tag(node) + [].map.call(x, attr_str).join('') + '>';
}

function moreIncompleteHtmlAttributeSanitization() {
	'<a' + noise + 'onclick="javascript:document.foo.bar(\'' + s().replace(/[<>"]/g, '') + '\'); return false;">'; // $ Alert[js/incomplete-html-attribute-sanitization]
	'="' + s().replace(/[<>]/g,'').replace(/[^\w ]+/g, '') + '"';
	'="' + encodeURIComponent(s().replace(/[<>]/g,'')) + '"';

	var arr = s().val().trim().replace(/^,|,$/g , '').replace(/^;|;$/g , '').replace(/<|>/g , ''); // $ Source[js/incomplete-html-attribute-sanitization]
	'="' + arr.join(" ") + '"'; // $ Alert[js/incomplete-html-attribute-sanitization]
	var arr2 = s().val().trim().replace(/^,|,$/g , '').replace(/^;|;$/g , '').replace(/<|>/g , '')
	arr2 = arr2.replace(/"/g,"");
	'="' + arr2.join(" ") + '"';

	var x;
	x = x.replace(/&/g, '&amp;');
	x = x.replace(/</g, '&lt;').replace(/>/g, '&gt;');
	'onclick="' + x + '"'; // $ MISSING: Alert - since the `x` replace chain is extended below
	x = x.replace(/"/g, '&quot;');
	'onclick="' + x + '"';

	var y;
	if (escapeAmpersand) {
		y = y.replace(/&/g, '&amp;');
	}
	y = y.replace(/</g, '&lt;').replace(/>/g, '&gt;');
	'onclick="' + y + '"'; // $ MISSING: Alert - since the `x` replace chain is extended below
	if (escapeQuotes) {
		y = y.replace(/"/g, '&quot;');
	}
	'onclick="' + y + '"';
}

function incompleteHtmlAttributeSanitization2() {
	'=\'' + s().replace(/[&<>]/g,'') + '\''; // $ Alert[js/incomplete-html-attribute-sanitization]
	'=\'' + s().replace(/[<>]/g,'') + '\''; // $ Alert[js/incomplete-html-attribute-sanitization]
	'=\'' + s().replace(/[&<>"]/g,'') + '\''; // $ Alert[js/incomplete-html-attribute-sanitization]
	'=\'' + s().replace(/[<>&]/g, '') + '\''; // $ Alert[js/incomplete-html-attribute-sanitization]
	'="' + s().replace(/[<>&"]/g,'') + '"';
	'=\'' + s().replace(/[<>&']/g,'') + '\'';
}

function incompleteComplexSanitizers() {
	'=\'' + s().replace(/[&<>"]/gm, function (str) {
		if (str === "&")
			return "&amp;";
		if (str === "<")
			return "&lt;";
		if (str === ">")
			return "&gt;";
		if (str === "\"")
			return "&quot;";
	}) + '\''; // $ Alert[js/incomplete-html-attribute-sanitization]

	'="' + s().replace(/[&<>"]/gm, function (str) {
		if (str === "&")
			return "&amp;";
		if (str === "<")
			return "&lt;";
		if (str === ">")
			return "&gt;";
		if (str === "\"")
			return "&quot;";
	}) + '"';
}

function typicalBadHtmlSanitizers(s) {
	s().replace(new RegExp("[<>]", "g"),'');
}

function typicalBadHtmlSanitizers(s) {
	s().replace(new RegExp("[<>]", unknown()),'');
}

function bad18NewRegExp(p) {
	return p.replace(new RegExp("\\.\\./"), ""); // $ Alert[js/incomplete-sanitization] Alert[js/incomplete-multi-character-sanitization] -- both lacking global flag, and multi-char replacement problem
}

function bad4NewRegExpG(s) {
	return s.replace(new RegExp("\'","g"), "\\$&"); // $ Alert[js/incomplete-sanitization]
}

function bad4NewRegExp(s) {
	return s.replace(new RegExp("\'"), "\\$&"); // $ Alert[js/incomplete-sanitization]
}

function bad4NewRegExpUnknown(s) {
	return s.replace(new RegExp("\'", unknownFlags()), "\\$&"); // $ Alert[js/incomplete-sanitization]
}

function newlinesNewReGexp(s) {
	require("child_process").execSync("which emacs").toString().replace(new RegExp("\n"), "");

	x.replace(new RegExp("\n", "g"), "").replace(x, y);
	x.replace(x, y).replace(new RegExp("\n", "g"), "");

	x.replace(new RegExp("\n"), "").replace(x, y); // $ Alert[js/incomplete-sanitization]
	x.replace(x, y).replace(new RegExp("\n"), ""); // $ Alert[js/incomplete-sanitization]

	x.replace(new RegExp("\n", unknownFlags()), "").replace(x, y);
	x.replace(x, y).replace(new RegExp("\n", unknownFlags()), "");
	x.replace(x, y).replace('}', ""); // $ Alert[js/incomplete-sanitization]
}
