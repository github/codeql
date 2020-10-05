# Exposure of private files

```
ID: js/exposure-of-private-files
Kind: problem
Severity: warning
Precision: high
Tags: security external/cwe/cwe-200

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/javascript/ql/src/Security/CWE-200/PrivateFileExposure.ql)

Libraries like `express` provide easy methods for serving entire directories of static files from a web server. However, using these can sometimes lead to accidental information exposure. If for example the `node_modules` folder is served, then an attacker can access the `_where` field from a `package.json` file, which gives access to the absolute path of the file.


## Recommendation
Limit which folders of static files are served from a web server.


## Example
In the example below, all the files from the `node_modules` are served. This allows clients to easily access all the files inside that folder, which includes potentially private information inside `package.json` files.


```javascript

var express = require('express');

var app = express();

app.use('/node_modules', express.static(path.resolve(__dirname, '../node_modules')));
```
The issue has been fixed below by only serving specific folders within the `node_modules` folder.


```javascript

var express = require('express');

var app = express();

app.use("jquery", express.static('./node_modules/jquery/dist'));
app.use("bootstrap", express.static('./node_modules/bootstrap/dist'));
```

## References
* OWASP: [Sensitive Data Exposure](https://www.owasp.org/index.php/Top_10-2017_A3-Sensitive_Data_Exposure).
* Common Weakness Enumeration: [CWE-200](https://cwe.mitre.org/data/definitions/200.html).