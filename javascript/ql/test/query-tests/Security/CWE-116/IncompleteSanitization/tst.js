let express = require('express');
var app = express();

function bad1(s) {
  return s.replace("'", ""); // NOT OK
}

function bad2(s) {
  return s.replace(/'/, ""); // NOT OK
}

function bad3(s) {
  return s.replace(/'/g, "\\'"); // NOT OK
}

function bad4(s) {
  return s.replace(/'/g, "\\$&"); // NOT OK
}

function bad5(s) {
  return s.replace(/['"]/g, "\\$&"); // NOT OK
}

function bad6(s) {
  return s.replace(/(['"])/g, "\\$1"); // NOT OK
}

function bad7(s) {
  return s.replace(/('|")/g, "\\$1"); // NOT OK
}

function bad8(s) {
  return s.replace('|', '');  // NOT OK
}

function bad9(s) {
  return s.replace(/"/g, "\\\"");  // NOT OK
}

function bad10(s) {
  return s.replace("/", "%2F"); // NOT OK
}

function bad11(s) {
  return s.replace("%25", "%"); // NOT OK
}

function bad12(s) {
  return s.replace(`'`, ""); // NOT OK
}

function bad13(s) {
  return s.replace("'", ``); // NOT OK
}

function bad14(s) {
  return s.replace(`'`, ``); // NOT OK
}

function bad15(s) {
  return s.replace("'" + "", ""); // NOT OK
}

function bad16(s) {
  return s.replace("'", "" + ""); // NOT OK
}

function bad17(s) {
  return s.replace("'" + "", "" + ""); // NOT OK
}

function good1(s) {
  while (s.indexOf("'") > 0)
    s = s.replace("'", ""); // OK
  return s;
}

function good2(s) {
  while (s.indexOf("'") > 0)
    s = s.replace(/'/, ""); // OK
  return s;
}

function good3(s) {
  return s.replace("@user", "id10t"); // OK
}

function good4(s) {
  return s.replace(/#/g, "\\d+"); // OK
}

function good5(s) {
  return s.replace(/\\/g, "\\\\").replace(/['"]/g, "\\$&"); // OK
}

function good6(s) {
  return s.replace(/[\\]/g, '\\\\').replace(/[\"]/g, '\\"'); // OK
}

function good7(s) {
  s = s.replace(/[\\]/g, '\\\\');
  return s.replace(/[\"]/g, '\\"'); // OK
}

function good8(s) {
  return s.replace(/\W/g, '\\$&'); // OK
}

function good9(s) {
  return s.replace(/[^\w\s]/g, '\\$&'); // OK
}

function good10(s) {
  s = JSON.stringify(s);  // NB: escapes backslashes
  s = s.slice(1, -1);
  s = s.replace(/\\"/g, '"');
  s = s.replace(/'/g, "\\'"); // OK
  return "'" + s + "'";
}

function flowifyComments(s) {
  return s.replace(/#/g, '💩'); // OK
}

function good11(s) {
  return s.replace("%d", "42");
}

function good12(s) {
	s.replace('[', '').replace(']', ''); // OK
	s.replace('(', '').replace(')', ''); // OK
	s.replace('{', '').replace('}', ''); // OK
	s.replace('<', '').replace('>', ''); // NOT OK: too common as a bad HTML sanitizer

	s.replace('[', '\\[').replace(']', '\\]'); // NOT OK
	s.replace('{', '\\{').replace('}', '\\}'); // NOT OK

	s = s.replace('[', ''); // OK
	s = s.replace(']', ''); // OK
	s.replace(/{/, '').replace(/}/, ''); // NOT OK: should have used a string literal if a single replacement was intended
	s.replace(']', '').replace('[', ''); // probably OK, but still flagged
}

function newlines(s) {
	// motivation for whitelist
	require("child_process").execSync("which emacs").toString().replace("\n", ""); // OK

	x.replace("\n", "").replace(x, y); // NOT OK
	x.replace(x, y).replace("\n", ""); // NOT OK
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
	return s.replace(indirect, ""); // NOT OK
});

(function (s) {
	s.replace('"', '').replace('"', ''); // OK
	s.replace("'", "").replace("'", ""); // OK
});

function bad18(p) {
  return p.replace("/../", ""); // NOT OK
}

function typicalBadHtmlSanitizers(s) {
	s().replace(/[<>]/g,''); // NOT OK
	s().replace(/[<>&]/g, ''); // NOT OK
	s().replace(/[<>"]/g, ''); // NOT OK
	s().replace(/</g, '').replace(/>/g, ''); // NOT OK
	s().replace(/</g, '').replace(/>/g, '').replace(/&/g, ''); // NOT OK
	s().replace(/</g, '').replace(/&/g, '').replace(/>/g, ''); // NOT OK
	s().replace(/&/g, '').replace(/>/g, '').replace(/</g, ''); // NOT OK

	var s = s().replace(/</g, '');
	s = s.replace(/>/g, '');  // NOT OK
	s().replace(/</g, '&lt;').replace(/>/g, '&gt').replace(/&/g, '&amp;').replace(/"/g, '&#34;'); // OK
	s().replace(/</g, '&lt;').replace(/>/g, '&gt').replace(/&/g, '&amp;').replace(/'/g, '&#39;'); // OK - single quotes or double quotes both work

	s().replace(/</g, '&lt;').replace(/>/g, '&gt').replace(RE, function(match) {/* ... */ }); // OK (probably)

	s().replace(/[<>'"&]/g,''); // OK

	s().replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;').replace(/&(?![\w\#]+;)/g, '&amp;'); // OK

	s().replace(!encode ? /&(?!#?\w+;)/g : /&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;').replace(/'/g, '&apos;'); // OK (and not recognized due to the ternary)

	s().replace(/[\\/:\*\?"<>\|]/g, ''); // OK

	s().replace(/[<>]/g,'_'); // OK (but probably unsafe)

	s().replace(/&/g, "&gt;"); // OK

	s().replace(/[\#\%4\/\-\~\>8\_\@0\!\&3\[651d\=e7fA2D\(aFBb]/g, ""); // OK

	s().replace(/[<>]/g,'').replace(/[^a-z]/g, ''); // OK

	s().replace(/[<>]/g,'').replace(/[^abc]/g, ''); // OK

	s().replace(/[<>]/g,'').replace(/[ -~]/g, ''); // OK
}

function incompleteHtmlAttributeSanitization() {
	'="' + s().replace(/[<>]/g,'') + '"'; // NOT OK
	'="' + s().replace(/[<>&]/g, '') + '"'; // NOT OK
	'="' + s().replace(/[<>"]/g, '') + '"'; // OK (maybe, since the attribute name is unknown)
	'="' + s().replace(/[<>&"]/g,'') + '"'; // OK
	'="' + s().replace(/[&"]/g,'') + '"'; // OK

	'="' + s().replace(/[<>&']/g,'') + '"'; // NOT OK
	"='" + s().replace(/[<>&"]/g,'') + "'"; // NOT OK
	"='" + s().replace(/[<>&']/g,'') + "'"; // OK

	'onFunkyEvent="' + s().replace(/[<>"]/g, '') + '"'; // NOT OK
	'<div noise onFunkyEvent="' + s().replace(/[<>"]/g, '') + '"'; // NOT OK
	'<div noise monday="' + s().replace(/[<>"]/g, '') + '"'; // OK
	'monday="' + s().replace(/[<>"]/g, '') + '"'; // OK
}

function multiStepSanitization() {
	function escapeHTML(value) {
		return value.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;');
	}
	function attr_str(a) {
		return ' ' + a.name + '="' + escapeHTML(a.value).replace(/"/g, '&quot;') + '"'; // OK
	}
	result += '<' + tag(node) + [].map.call(x, attr_str).join('') + '>';
}

function moreIncompleteHtmlAttributeSanitization() {
	'<a' + noise + 'onclick="javascript:document.foo.bar(\'' + s().replace(/[<>"]/g, '') + '\'); return false;">'; // NOT OK
	'="' + s().replace(/[<>]/g,'').replace(/[^\w ]+/g, '') + '"'; // OK
	'="' + encodeURIComponent(s().replace(/[<>]/g,'')) + '"'; // OK

	var arr = s().val().trim().replace(/^,|,$/g , '').replace(/^;|;$/g , '').replace(/<|>/g , '');
	'="' + arr.join(" ") + '"'; // NOT OK
	var arr2 = s().val().trim().replace(/^,|,$/g , '').replace(/^;|;$/g , '').replace(/<|>/g , '')
	arr2 = arr2.replace(/"/g,"");
	'="' + arr2.join(" ") + '"'; // OK

	var x;
	x = x.replace(/&/g, '&amp;');
	x = x.replace(/</g, '&lt;').replace(/>/g, '&gt;');
	'onclick="' + x + '"'; // NOT OK - but not flagged since the `x` replace chain is extended below
	x = x.replace(/"/g, '&quot;');
	'onclick="' + x + '"'; // OK

	var y;
	if (escapeAmpersand) {
		y = y.replace(/&/g, '&amp;');
	}
	y = y.replace(/</g, '&lt;').replace(/>/g, '&gt;');
	'onclick="' + y + '"'; // NOT OK - but not flagged since the `x` replace chain is extended below
	if (escapeQuotes) {
		y = y.replace(/"/g, '&quot;');
	}
	'onclick="' + y + '"'; // OK
}

function incompleteHtmlAttributeSanitization2() {
	'=\'' + s().replace(/[&<>]/g,'') + '\''; // NOT OK
	'=\'' + s().replace(/[<>]/g,'') + '\''; // NOT OK
	'=\'' + s().replace(/[&<>"]/g,'') + '\''; // NOT OK
	'=\'' + s().replace(/[<>&]/g, '') + '\''; // NOT OK
	'="' + s().replace(/[<>&"]/g,'') + '"'; // OK
	'=\'' + s().replace(/[<>&']/g,'') + '\''; // OK
}

function incompleteComplexSanitizers() {
	'=\'' + s().replace(/[&<>"]/gm, function (str) { // NOT OK
		if (str === "&")
			return "&amp;";
		if (str === "<")
			return "&lt;";
		if (str === ">")
			return "&gt;";
		if (str === "\"")
			return "&quot;";
	}) + '\'';

	'="' + s().replace(/[&<>"]/gm, function (str) { // OK
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