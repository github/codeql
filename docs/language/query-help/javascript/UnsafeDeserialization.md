# Deserialization of user-controlled data

```
ID: js/unsafe-deserialization
Kind: path-problem
Severity: warning
Precision: high
Tags: security external/cwe/cwe-502

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/javascript/ql/src/Security/CWE-502/UnsafeDeserialization.ql)

Deserializing untrusted data using any deserialization framework that allows the construction of arbitrary functions is easily exploitable and, in many cases, allows an attacker to execute arbitrary code.


## Recommendation
Avoid deserialization of untrusted data if at all possible. If the architecture permits it, then use formats like JSON or XML that cannot represent functions. When using YAML or other formats that support the serialization and deserialization of functions, ensure that the parser is configured to disable deserialization of arbitrary functions.


## Example
The following example calls the `load` function of the popular `js-yaml` package on data that comes from an HTTP request and hence is inherently unsafe.


```javascript
const app = require("express")(),
  jsyaml = require("js-yaml");

app.get("load", function(req, res) {
  let data = jsyaml.load(req.params.data);
  // ...
});

```
Using the `safeLoad` function instead (which does not deserialize YAML-encoded functions) removes the vulnerability.


```javascript
const app = require("express")(),
  jsyaml = require("js-yaml");

app.get("load", function(req, res) {
  let data = jsyaml.safeLoad(req.params.data);
  // ...
});

```

## References
* OWASP vulnerability description: [Deserialization of untrusted data](https://www.owasp.org/index.php/Deserialization_of_untrusted_data).
* OWASP guidance on deserializing objects: [Deserialization Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Deserialization_Cheat_Sheet.html).
* Neal Poole: [Code Execution via YAML in JS-YAML Node.js Module](https://nealpoole.com/blog/2013/06/code-execution-via-yaml-in-js-yaml-nodejs-module/).
* Common Weakness Enumeration: [CWE-502](https://cwe.mitre.org/data/definitions/502.html).