# Hard-coded data interpreted as code

```
ID: js/hardcoded-data-interpreted-as-code
Kind: path-problem
Severity: error
Precision: medium
Tags: security external/cwe/cwe-506

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/javascript/ql/src/Security/CWE-506/HardcodedDataInterpretedAsCode.ql)

Interpreting hard-coded data, such as string literals containing hexadecimal numbers, as code or as an import path is typical of malicious backdoor code that has been implanted into an otherwise trusted code base and is trying to hide its true purpose from casual readers or automated scanning tools.


## Recommendation
Examine the code in question carefully to ascertain its provenance and its true purpose. If the code is benign, it should always be possible to rewrite it without relying on dynamically interpreting data as code, improving both clarity and safety.


## Example
As an example of malicious code using this obfuscation technique, consider the following simplified version of a snippet of backdoor code that was discovered in a dependency of the popular `event-stream` npm package:


```javascript
var r = require;

function e(r) {
  return Buffer.from(r, "hex").toString()
}

// BAD: hexadecimal constant decoded and interpreted as import path
var n = r(e("2e2f746573742f64617461"));

```
While this shows only the first few lines of code, it already looks very suspicious since it takes a hard-coded string literal, hex-decodes it and then uses it as an import path. The only reason to do so is to hide the name of the file being imported.


## References
* OWASP: [Trojan Horse](https://www.owasp.org/index.php/Trojan_Horse).
* The npm Blog: [Details about the event-stream incident](https://blog.npmjs.org/post/180565383195/details-about-the-event-stream-incident).
* Common Weakness Enumeration: [CWE-506](https://cwe.mitre.org/data/definitions/506.html).