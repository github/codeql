# Disabling certificate validation

```
ID: js/disabling-certificate-validation
Kind: problem
Severity: error
Precision: very-high
Tags: security external/cwe-295

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/javascript/ql/src/Security/CWE-295/DisablingCertificateValidation.ql)

Certificate validation is the standard authentication method of a secure TLS connection. Without it, there is no guarantee about who the other party of a TLS connection is, making man-in-the-middle attacks more likely to occur

When testing software that uses TLS connections, it may be useful to disable the certificate validation temporarily. But disabling it in production environments is strongly discouraged, unless an alternative method of authentication is used.


## Recommendation
Do not disable certificate validation for TLS connections.


## Example
The following example shows a HTTPS connection that transfers confidential information to a remote server. But the connection is not secure since the `rejectUnauthorized` option of the connection is set to `false`. As a consequence, anyone can impersonate the remote server, and receive the confidential information.


```javascript
let https = require("https");

https.request(
  {
    hostname: "secure.my-online-bank.com",
    port: 443,
    method: "POST",
    path: "send-confidential-information",
    rejectUnauthorized: false // BAD
  },
  response => {
    // ... communicate with secure.my-online-bank.com
  }
);

```
To make the connection secure, the `rejectUnauthorized` option should have its default value, or be explicitly set to `true`.


## References
* Wikipedia: [Transport Layer Security (TLS)](https://en.wikipedia.org/wiki/Transport_Layer_Security)
* Wikipedia: [Man-in-the-middle attack](https://en.wikipedia.org/wiki/Man-in-the-middle_attack)
* Node.js: [TLS (SSL)](https://nodejs.org/api/tls.html)