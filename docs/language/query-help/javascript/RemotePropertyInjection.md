# Remote property injection

```
ID: js/remote-property-injection
Kind: path-problem
Severity: warning
Precision: medium
Tags: security external/cwe/cwe-250 external/cwe/cwe-400

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/javascript/ql/src/Security/CWE-400/RemotePropertyInjection.ql)

Dynamically computing object property names from untrusted input may have multiple undesired consequences. For example, if the property access is used as part of a write, an attacker may overwrite vital properties of objects, such as `__proto__`. This attack is known as *prototype pollution attack* and may serve as a vehicle for denial-of-service attacks. A similar attack vector, is to replace the `toString` property of an object with a primitive. Whenever `toString` is then called on that object, either explicitly or implicitly as part of a type coercion, an exception will be raised.

Moreover, if the name of an HTTP header is user-controlled, an attacker may exploit this to overwrite security-critical headers such as `Access-Control-Allow-Origin` or `Content-Security-Policy`.


## Recommendation
The most common case in which prototype pollution vulnerabilities arise is when JavaScript objects are used for implementing map data structures. This case should be avoided whenever possible by using the ECMAScript 2015 `Map` instead. When this is not possible, an alternative fix is to prepend untrusted input with a marker character such as `$`, before using it in properties accesses. In this way, the attacker does not have access to built-in properties which do not start with the chosen character.

When using user input as part of a header name, a sanitization step should be performed on the input to ensure that the name does not clash with existing header names such as `Content-Security-Policy`.


## Example
In the example below, the dynamically computed property `prop` is accessed on `myObj` using a user-controlled value.


```javascript
var express = require('express');

var app = express();
var myObj = {}

app.get('/user/:id', function(req, res) {
	var prop = req.query.userControlled; // BAD
	myObj[prop] = function() {};
	console.log("Request object " + myObj);
});
```
This is not secure since an attacker may exploit this code to overwrite the property `__proto__` with an empty function. If this happens, the concatenation in the `console.log` argument will fail with a confusing message such as "Function.prototype.toString is not generic". If the application does not properly handle this error, this scenario may result in a serious denial-of-service attack. The fix is to prepend the user-controlled string with a marker character such as `$` which will prevent arbitrary property names from being overwritten.


```javascript
var express = require('express');

var app = express();
var myObj = {}

app.get('/user/:id', function(req, res) {
	var prop = "$" + req.query.userControlled; // GOOD
	myObj[prop] = function() {};
	console.log("Request object " + myObj);
});
```

## References
* Prototype pollution attacks: [electron](https://github.com/electron/electron/pull/9287), [lodash](https://hackerone.com/reports/310443), [hoek](https://nodesecurity.io/advisories/566).
* Penetration testing report: [ header name injection attack](http://seclists.org/pen-test/2009/Mar/67)
* npm blog post: [ dangers of square bracket notation](https://blog.liftsecurity.io/2015/01/14/the-dangers-of-square-bracket-notation#lift-security)
* Common Weakness Enumeration: [CWE-250](https://cwe.mitre.org/data/definitions/250.html).
* Common Weakness Enumeration: [CWE-400](https://cwe.mitre.org/data/definitions/400.html).