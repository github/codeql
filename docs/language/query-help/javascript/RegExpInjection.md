# Regular expression injection

```
ID: js/regex-injection
Kind: path-problem
Severity: error
Precision: high
Tags: security external/cwe/cwe-730 external/cwe/cwe-400

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/javascript/ql/src/Security/CWE-730/RegExpInjection.ql)

Constructing a regular expression with unsanitized user input is dangerous as a malicious user may be able to modify the meaning of the expression. In particular, such a user may be able to provide a regular expression fragment that takes exponential time in the worst case, and use that to perform a Denial of Service attack.


## Recommendation
Before embedding user input into a regular expression, use a sanitization function such as lodash's `_.escapeRegExp` to escape meta-characters that have special meaning.


## Example
The following example shows a HTTP request parameter that is used to construct a regular expression without sanitizing it first:


```javascript
var express = require('express');
var app = express();

app.get('/findKey', function(req, res) {
  var key = req.param("key"), input = req.param("input");

  // BAD: Unsanitized user input is used to construct a regular expression
  var re = new RegExp("\\b" + key + "=(.*)\n");
});

```
Instead, the request parameter should be sanitized first, for example using the function `_.escapeRegExp` from the lodash package. This ensures that the user cannot insert characters which have a special meaning in regular expressions.


```javascript
var express = require('express');
var _ = require('lodash');
var app = express();

app.get('/findKey', function(req, res) {
  var key = req.param("key"), input = req.param("input");

  // GOOD: User input is sanitized before constructing the regex
  var safeKey = _.escapeRegExp(key);
  var re = new RegExp("\\b" + safeKey + "=(.*)\n");
});

```

## References
* OWASP: [Regular expression Denial of Service - ReDoS](https://www.owasp.org/index.php/Regular_expression_Denial_of_Service_-_ReDoS).
* Wikipedia: [ReDoS](https://en.wikipedia.org/wiki/ReDoS).
* npm: [lodash](https://www.npmjs.com/package/lodash).
* Common Weakness Enumeration: [CWE-730](https://cwe.mitre.org/data/definitions/730.html).
* Common Weakness Enumeration: [CWE-400](https://cwe.mitre.org/data/definitions/400.html).