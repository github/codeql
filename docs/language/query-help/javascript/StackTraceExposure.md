# Information exposure through a stack trace

```
ID: js/stack-trace-exposure
Kind: path-problem
Severity: warning
Precision: very-high
Tags: security external/cwe/cwe-209

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/javascript/ql/src/Security/CWE-209/StackTraceExposure.ql)

Software developers often add stack traces to error messages, as a debugging aid. Whenever that error message occurs for an end user, the developer can use the stack trace to help identify how to fix the problem. In particular, stack traces can tell the developer more about the sequence of events that led to a failure, as opposed to merely the final state of the software when the error occurred.

Unfortunately, the same information can be useful to an attacker. The sequence of function names in a stack trace can reveal the structure of the application as well as any internal components it relies on. Furthermore, the error message at the top of a stack trace can include information such as server-side file names and SQL code that the application relies on, allowing an attacker to fine-tune a subsequent injection attack.


## Recommendation
Send the user a more generic error message that reveals less information. Either suppress the stack trace entirely, or log it only on the server.


## Example
In the following example, an exception is caught and its stack trace is sent back to the remote user as part of the HTTP response. As such, the user is able to see a detailed stack trace, which may contain sensitive information.


```javascript
var http = require('http');

http.createServer(function onRequest(req, res) {
  var body;
  try {
    body = handleRequest(req);
  }
  catch (err) {
    res.statusCode = 500;
    res.setHeader("Content-Type", "text/plain");
    res.end(err.stack); // NOT OK
    return;
  }
  res.statusCode = 200;
  res.setHeader("Content-Type", "application/json");
  res.setHeader("Content-Length", body.length);
  res.end(body);
}).listen(3000);

```
Instead, the stack trace should be logged only on the server. That way, the developers can still access and use the error log, but remote users will not see the information:


```javascript
var http = require('http');

http.createServer(function onRequest(req, res) {
  var body;
  try {
    body = handleRequest(req);
  }
  catch (err) {
    res.statusCode = 500;
    res.setHeader("Content-Type", "text/plain");
    log("Exception occurred", err.stack);
    res.end("An exception occurred"); // OK
    return;
  }
  res.statusCode = 200;
  res.setHeader("Content-Type", "application/json");
  res.setHeader("Content-Length", body.length);
  res.end(body);
}).listen(3000);

```

## References
* OWASP: [Information Leak](https://www.owasp.org/index.php/Information_Leak_(information_disclosure)).
* Common Weakness Enumeration: [CWE-209](https://cwe.mitre.org/data/definitions/209.html).