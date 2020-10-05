# Type confusion through parameter tampering

```
ID: js/type-confusion-through-parameter-tampering
Kind: path-problem
Severity: error
Precision: high
Tags: security external/cwe/cwe-843

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/javascript/ql/src/Security/CWE-843/TypeConfusionThroughParameterTampering.ql)

Sanitizing untrusted HTTP request parameters is an important technique for preventing injection attacks such as SQL injection or path traversal. This is sometimes done by checking if the request parameters contain blacklisted substrings.

However, sanitizing request parameters assuming they have type `String` and using the builtin string methods such as `String.prototype.indexOf` is susceptible to type confusion attacks. In a type confusion attack, an attacker tampers with an HTTP request parameter such that it has a value of type `Array` instead of the expected type `String`. Furthermore, the content of the array has been crafted to bypass sanitizers by exploiting that some identically named methods of strings and arrays behave differently.


## Recommendation
Check the runtime type of sanitizer inputs if the input type is user-controlled.


## Example
For example, Node.js server frameworks usually present request parameters as strings. But if an attacker sends multiple request parameters with the same name, then the request parameter is represented as an array instead.

In the following example, a sanitizer checks that a path does not contain the `".."` string, which would allow an attacker to access content outside a user-accessible directory.


```javascript
var app = require("express")(),
  path = require("path");

app.get("/user-files", function(req, res) {
  var file = req.param("file");
  if (file.indexOf("..") !== -1) {
    // BAD
    // forbid paths outside the /public directory
    res.status(400).send("Bad request");
  } else {
    var absolute = path.resolve("/public/" + file);
    console.log("Sending file: %s", absolute);
    res.sendFile(absolute);
  }
});

```
As written, this sanitizer is ineffective: an array like `["../", "/../secret.txt"]` will bypass the sanitizer. The array does not contain `".."` as an element, so the call to `indexOf` returns `-1` . This is problematic since the value of the `absolute` variable then ends up being `"/secret.txt"`. This happens since the concatenation of `"/public/"` and the array results in `"/public/../,/../secret.txt"`, which the `resolve`-call converts to `"/secret.txt"`.

To fix the sanitizer, check that the request parameter is a string, and not an array:


```javascript
var app = require("express")(),
  path = require("path");

app.get("/user-files", function(req, res) {
  var file = req.param("file");
  if (typeof path !== 'string' || file.indexOf("..") !== -1) {
    // BAD
    // forbid paths outside the /public directory
    res.status(400).send("Bad request");
  } else {
    var absolute = path.resolve("/public/" + file);
    console.log("Sending file: %s", absolute);
    res.sendFile(absolute);
  }
});

```

## References
* Node.js API: [querystring](https://nodejs.org/api/querystring.html).
* Common Weakness Enumeration: [CWE-843](https://cwe.mitre.org/data/definitions/843.html).