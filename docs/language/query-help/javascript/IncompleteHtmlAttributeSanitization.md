# Incomplete HTML attribute sanitization

```
ID: js/incomplete-html-attribute-sanitization
Kind: path-problem
Severity: warning
Precision: high
Tags: security external/cwe/cwe-079 external/cwe/cwe-116 external/cwe/cwe-20

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/javascript/ql/src/Security/CWE-116/IncompleteHtmlAttributeSanitization.ql)

Sanitizing untrusted input for HTML meta-characters is an important technique for preventing cross-site scripting attacks. Usually, this is done by escaping `<`, `>`, `&` and `"`. However, the context in which the sanitized value is used decides the characters that need to be sanitized.

As a consequence, some programs only sanitize `<` and `>` since those are the most common dangerous characters. The lack of sanitization for `"` is problematic when an incompletely sanitized value is used as an HTML attribute in a string that later is parsed as HTML.


## Recommendation
Sanitize all relevant HTML meta-characters when constructing HTML dynamically, and pay special attention to where the sanitized value is used.


## Example
The following example code writes part of an HTTP request (which is controlled by the user) to an HTML attribute of the server response. The user-controlled value is, however, not sanitized for `"`. This leaves the website vulnerable to cross-site scripting since an attacker can use a string like `" onclick="alert(42)` to inject JavaScript code into the response.


```javascript
var app = require('express')();

app.get('/user/:id', function(req, res) {
	let id = req.params.id;
	id = id.replace(/<|>/g, ""); // BAD
	let userHtml = `<div data-id="${id}">${getUserName(id) || "Unknown name"}</div>`;
	// ...
	res.send(prefix + userHtml + suffix);
});

```
Sanitizing the user-controlled data for `"` helps prevent the vulnerability:


```javascript
var app = require('express')();

app.get('/user/:id', function(req, res) {
	let id = req.params.id;
	id = id.replace(/<|>|&|"/g, ""); // GOOD
	let userHtml = `<div data-id="${id}">${getUserName(id) || "Unknown name"}</div>`;
	// ...
	res.send(prefix + userHtml + suffix);
});

```

## References
* OWASP: [DOM based XSS Prevention Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/DOM_based_XSS_Prevention_Cheat_Sheet.html).
* OWASP: [XSS (Cross Site Scripting) Prevention Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Cross_Site_Scripting_Prevention_Cheat_Sheet.html).
* OWASP [Types of Cross-Site](https://owasp.org/www-community/Types_of_Cross-Site_Scripting).
* Wikipedia: [Cross-site scripting](http://en.wikipedia.org/wiki/Cross-site_scripting).
* Common Weakness Enumeration: [CWE-79](https://cwe.mitre.org/data/definitions/79.html).
* Common Weakness Enumeration: [CWE-116](https://cwe.mitre.org/data/definitions/116.html).
* Common Weakness Enumeration: [CWE-20](https://cwe.mitre.org/data/definitions/20.html).