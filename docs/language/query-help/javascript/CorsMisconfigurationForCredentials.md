# CORS misconfiguration for credentials transfer

```
ID: js/cors-misconfiguration-for-credentials
Kind: path-problem
Severity: error
Precision: high
Tags: security external/cwe/cwe-346 external/cwe/cwe-639

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/javascript/ql/src/Security/CWE-346/CorsMisconfigurationForCredentials.ql)

A server can send the `"Access-Control-Allow-Credentials"` CORS header to control when a browser may send user credentials in Cross-Origin HTTP requests.

When the `Access-Control-Allow-Credentials` header is `"true"`, the `Access-Control-Allow-Origin` header must have a value different from `"*"` in order to make browsers accept the header. Therefore, to allow multiple origins for Cross-Origin requests with credentials, the server must dynamically compute the value of the `"Access-Control-Allow-Origin"` header. Computing this header value from information in the request to the server can therefore potentially allow an attacker to control the origins that the browser sends credentials to.


## Recommendation
When the `Access-Control-Allow-Credentials` header value is `"true"`, a dynamic computation of the `Access-Control-Allow-Origin` header must involve sanitization if it relies on user-controlled input.

Since the `"null"` origin is easy to obtain for an attacker, it is never safe to use `"null"` as the value of the `Access-Control-Allow-Origin` header when the `Access-Control-Allow-Credentials` header value is `"true"`.


## Example
In the example below, the server allows the browser to send user credentials in a Cross-Origin request. The request header `origins` controls the allowed origins for such a Cross-Origin request.


```javascript
var https = require('https'),
    url = require('url');

var server = https.createServer(function(){});

server.on('request', function(req, res) {
    let origin = url.parse(req.url, true).query.origin;
     // BAD: attacker can choose the value of origin
    res.setHeader("Access-Control-Allow-Origin", origin);
    res.setHeader("Access-Control-Allow-Credentials", true);

    // ...
});

```
This is not secure, since an attacker can choose the value of the `origin` request header to make the browser send credentials to their own server. The use of a whitelist containing allowed origins for the Cross-Origin request fixes the issue:


```javascript
var https = require('https'),
    url = require('url');

var server = https.createServer(function(){});

server.on('request', function(req, res) {
    let origin = url.parse(req.url, true).query.origin,
        whitelist = {
            "https://example.com": true,
            "https://subdomain.example.com": true,
            "https://example.com:1337": true
        };

    if (origin in whitelist) {
        // GOOD: the origin is in the whitelist
        res.setHeader("Access-Control-Allow-Origin", origin);
        res.setHeader("Access-Control-Allow-Credentials", true);
    }

    // ...
});

```

## References
* Mozilla Developer Network: [CORS, Access-Control-Allow-Origin](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Access-Control-Allow-Origin).
* Mozilla Developer Network: [CORS, Access-Control-Allow-Credentials](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Access-Control-Allow-Credentials).
* PortSwigger: [Exploiting CORS Misconfigurations for Bitcoins and Bounties](http://blog.portswigger.net/2016/10/exploiting-cors-misconfigurations-for.html)
* W3C: [CORS for developers, Advice for Resource Owners](https://w3c.github.io/webappsec-cors-for-developers/#resources)
* Common Weakness Enumeration: [CWE-346](https://cwe.mitre.org/data/definitions/346.html).
* Common Weakness Enumeration: [CWE-639](https://cwe.mitre.org/data/definitions/639.html).