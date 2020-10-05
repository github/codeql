# Missing rate limiting

```
ID: js/missing-rate-limiting
Kind: problem
Severity: error
Precision: high
Tags: security external/cwe/cwe-770 external/cwe/cwe-307 external/cwe/cwe-400

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/javascript/ql/src/Security/CWE-770/MissingRateLimiting.ql)

HTTP request handlers should not perform expensive operations such as accessing the file system, executing an operating system command or interacting with a database without limiting the rate at which requests are accepted. Otherwise, the application becomes vulnerable to denial-of-service attacks where an attacker can cause the application to crash or become unresponsive by issuing a large number of requests at the same time.


## Recommendation
A rate-limiting middleware should be used to prevent such attacks.


## Example
The following example shows an Express application that serves static files without rate limiting:


```javascript
var express = require('express');
var app = express();

app.get('/:path', function(req, res) {
  let path = req.params.path;
  if (isValidPath(path))
    res.sendFile(path);
});

```
To prevent denial-of-service attacks, the `express-rate-limit` package can be used:


```javascript
var express = require('express');
var app = express();

// set up rate limiter: maximum of five requests per minute
var RateLimit = require('express-rate-limit');
var limiter = new RateLimit({
  windowMs: 1*60*1000, // 1 minute
  max: 5
});

// apply rate limiter to all requests
app.use(limiter);

app.get('/:path', function(req, res) {
  let path = req.params.path;
  if (isValidPath(path))
    res.sendFile(path);
});

```

## References
* OWASP: [Denial of Service Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Denial_of_Service_Cheat_Sheet.html).
* Wikipedia: [Denial-of-service attack](https://en.wikipedia.org/wiki/Denial-of-service_attack).
* NPM: [express-rate-limit](https://www.npmjs.com/package/express-rate-limit).
* Common Weakness Enumeration: [CWE-770](https://cwe.mitre.org/data/definitions/770.html).
* Common Weakness Enumeration: [CWE-307](https://cwe.mitre.org/data/definitions/307.html).
* Common Weakness Enumeration: [CWE-400](https://cwe.mitre.org/data/definitions/400.html).