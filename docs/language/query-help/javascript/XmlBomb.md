# XML internal entity expansion

```
ID: js/xml-bomb
Kind: path-problem
Severity: warning
Precision: high
Tags: security external/cwe/cwe-776 external/cwe/cwe-400

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/javascript/ql/src/Security/CWE-776/XmlBomb.ql)

Parsing untrusted XML files with a weakly configured XML parser may be vulnerable to denial-of-service (DoS) attacks exploiting uncontrolled internal entity expansion.

In XML, so-called *internal entities* are a mechanism for introducing an abbreviation for a piece of text or part of a document. When a parser that has been configured to expand entities encounters a reference to an internal entity, it replaces the entity by the data it represents. The replacement text may itself contain other entity references, which are expanded recursively. This means that entity expansion can increase document size dramatically.

If untrusted XML is parsed with entity expansion enabled, a malicious attacker could submit a document that contains very deeply nested entity definitions, causing the parser to take a very long time or use large amounts of memory. This is sometimes called an *XML bomb* attack.


## Recommendation
The safest way to prevent XML bomb attacks is to disable entity expansion when parsing untrusted data. How this is done depends on the library being used. Note that some libraries, such as recent versions of `libxmljs` (though not its SAX parser API), disable entity expansion by default, so unless you have explicitly enabled entity expansion, no further action is needed.


## Example
The following example uses the XML parser provided by the `node-expat` package to parse a string `xmlSrc`. If that string is from an untrusted source, this code may be vulnerable to a DoS attack, since `node-expat` expands internal entities by default:


```javascript
const app = require("express")(),
  expat = require("node-expat");

app.post("upload", (req, res) => {
  let xmlSrc = req.body,
    parser = new expat.Parser();
  parser.on("startElement", handleStart);
  parser.on("text", handleText);
  parser.write(xmlSrc);
});

```
At the time of writing, `node-expat` does not provide a way of controlling entity expansion, but the example could be rewritten to use the `sax` package instead, which only expands standard entities such as `&amp;`:


```javascript
const app = require("express")(),
  sax = require("sax");

app.post("upload", (req, res) => {
  let xmlSrc = req.body,
    parser = sax.parser(true);
  parser.onopentag = handleStart;
  parser.ontext = handleText;
  parser.write(xmlSrc);
});

```

## References
* Wikipedia: [Billion Laughs](https://en.wikipedia.org/wiki/Billion_laughs).
* Bryan Sullivan: [Security Briefs - XML Denial of Service Attacks and Defenses](https://msdn.microsoft.com/en-us/magazine/ee335713.aspx).
* Common Weakness Enumeration: [CWE-776](https://cwe.mitre.org/data/definitions/776.html).
* Common Weakness Enumeration: [CWE-400](https://cwe.mitre.org/data/definitions/400.html).