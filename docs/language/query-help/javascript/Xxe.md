# XML external entity expansion

```
ID: js/xxe
Kind: path-problem
Severity: error
Precision: high
Tags: security external/cwe/cwe-611 external/cwe/cwe-827

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/javascript/ql/src/Security/CWE-611/Xxe.ql)

Parsing untrusted XML files with a weakly configured XML parser may lead to an XML External Entity (XXE) attack. This type of attack uses external entity references to access arbitrary files on a system, carry out denial-of-service (DoS) attacks, or server-side request forgery. Even when the result of parsing is not returned to the user, DoS attacks are still possible and out-of-band data retrieval techniques may allow attackers to steal sensitive data.


## Recommendation
The easiest way to prevent XXE attacks is to disable external entity handling when parsing untrusted data. How this is done depends on the library being used. Note that some libraries, such as recent versions of `libxml`, disable entity expansion by default, so unless you have explicitly enabled entity expansion, no further action needs to be taken.


## Example
The following example uses the `libxml` XML parser to parse a string `xmlSrc`. If that string is from an untrusted source, this code may be vulnerable to an XXE attack, since the parser is invoked with the `noent` option set to `true`:


```javascript
const app = require("express")(),
  libxml = require("libxmljs");

app.post("upload", (req, res) => {
  let xmlSrc = req.body,
    doc = libxml.parseXml(xmlSrc, { noent: true });
});

```
To guard against XXE attacks, the `noent` option should be omitted or set to `false`. This means that no entity expansion is undertaken at all, not even for standard internal entities such as `&amp;` or `&gt;`. If desired, these entities can be expanded in a separate step using utility functions provided by libraries such as [underscore](http://underscorejs.org/#unescape), [lodash](https://lodash.com/docs/latest#unescape) or [he](https://github.com/mathiasbynens/he).


```javascript
const app = require("express")(),
  libxml = require("libxmljs");

app.post("upload", (req, res) => {
  let xmlSrc = req.body,
    doc = libxml.parseXml(xmlSrc);
});

```

## References
* OWASP: [XML External Entity (XXE) Processing](https://www.owasp.org/index.php/XML_External_Entity_(XXE)_Processing).
* Timothy Morgen: [XML Schema, DTD, and Entity Attacks](https://www.vsecurity.com//download/publications/XMLDTDEntityAttacks.pdf).
* Timur Yunusov, Alexey Osipov: [XML Out-Of-Band Data Retrieval](https://media.blackhat.com/eu-13/briefings/Osipov/bh-eu-13-XML-data-osipov-slides.pdf).
* Common Weakness Enumeration: [CWE-611](https://cwe.mitre.org/data/definitions/611.html).
* Common Weakness Enumeration: [CWE-827](https://cwe.mitre.org/data/definitions/827.html).