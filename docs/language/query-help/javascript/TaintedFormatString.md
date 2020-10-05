# Use of externally-controlled format string

```
ID: js/tainted-format-string
Kind: path-problem
Severity: warning
Precision: high
Tags: security external/cwe/cwe-134

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/javascript/ql/src/Security/CWE-134/TaintedFormatString.ql)

Functions like the Node.js standard library function `util.format` accept a format string that is used to format the remaining arguments by providing inline format specifiers. If the format string contains unsanitized input from an untrusted source, then that string may contain unexpected format specifiers that cause garbled output.


## Recommendation
Either sanitize the input before including it in the format string, or use a `%s` specifier in the format string, and pass the untrusted data as corresponding argument.


## Example
The following program snippet logs information about an unauthorized access attempt. The log message includes the user name, and the user's IP address is passed as an additional argument to `console.log` to be appended to the message:


```javascript
const app = require("express")();

app.get("unauthorized", function handler(req, res) {
  let user = req.query.user;
  let ip = req.connection.remoteAddress;
  console.log("Unauthorized access attempt by " + user, ip);
});

```
However, if a malicious user provides `%d` as their user name, `console.log` will instead attempt to format the `ip` argument as a number. Since IP addresses are not valid numbers, the result of this conversion is `NaN`. The resulting log message will read "Unauthorized access attempt by NaN", missing all the information that it was trying to log in the first place.

Instead, the user name should be included using the `%s` specifier:


```javascript
const app = require("express")();

app.get("unauthorized", function handler(req, res) {
  let user = req.query.user;
  let ip = req.connection.remoteAddress;
  console.log("Unauthorized access attempt by %s", user, ip);
});

```

## References
* Node.js Documentation: [util.format](https://nodejs.org/api/util.html#util_util_format_format_args).
* Common Weakness Enumeration: [CWE-134](https://cwe.mitre.org/data/definitions/134.html).