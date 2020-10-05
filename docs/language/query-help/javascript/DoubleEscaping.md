# Double escaping or unescaping

```
ID: js/double-escaping
Kind: problem
Severity: warning
Precision: high
Tags: correctness security external/cwe/cwe-116 external/cwe/cwe-20

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/javascript/ql/src/Security/CWE-116/DoubleEscaping.ql)

Escaping meta-characters in untrusted input is an important technique for preventing injection attacks such as cross-site scripting. One particular example of this is HTML entity encoding, where HTML special characters are replaced by HTML character entities to prevent them from being interpreted as HTML markup. For example, the less-than character is encoded as `&lt;` and the double-quote character as `&quot;`. Other examples include backslash-escaping for including untrusted data in string literals and percent-encoding for URI components.

The reverse process of replacing escape sequences with the characters they represent is known as unescaping.

Note that the escape characters themselves (such as ampersand in the case of HTML encoding) play a special role during escaping and unescaping: they are themselves escaped, but also form part of the escaped representations of other characters. Hence care must be taken to avoid double escaping and unescaping: when escaping, the escape character must be escaped first, when unescaping it has to be unescaped last.

If used in the context of sanitization, double unescaping may render the sanitization ineffective. Even if it is not used in a security-critical context, it may still result in confusing or garbled output.


## Recommendation
Use a (well-tested) sanitization library if at all possible. These libraries are much more likely to handle corner cases correctly than a custom implementation. For URI encoding, you can use the standard `encodeURIComponent` and `decodeURIComponent` functions.

Otherwise, make sure to always escape the escape character first, and unescape it last.


## Example
The following example shows a pair of hand-written HTML encoding and decoding functions:


```javascript
module.exports.encode = function(s) {
  return s.replace(/&/g, "&amp;")
          .replace(/"/g, "&quot;")
          .replace(/'/g, "&apos;");
};

module.exports.decode = function(s) {
  return s.replace(/&amp;/g, "&")
          .replace(/&quot;/g, "\"")
          .replace(/&apos;/g, "'");
};

```
The encoding function correctly handles ampersand before the other characters. For example, the string `me & "you"` is encoded as `me &amp; &quot;you&quot;`, and the string `&quot;` is encoded as `&amp;quot;`.

The decoding function, however, incorrectly decodes `&amp;` into `&` before handling the other characters. So while it correctly decodes the first example above, it decodes the second example (`&amp;quot;`) to `"` (a single double quote), which is not correct.

Instead, the decoding function should decode the ampersand last:


```javascript
module.exports.encode = function(s) {
  return s.replace(/&/g, "&amp;")
          .replace(/"/g, "&quot;")
          .replace(/'/g, "&apos;");
};

module.exports.decode = function(s) {
  return s.replace(/&quot;/g, "\"")
          .replace(/&apos;/g, "'")
          .replace(/&amp;/g, "&");
};

```

## References
* OWASP Top 10: [A1 Injection](https://www.owasp.org/index.php/Top_10-2017_A1-Injection).
* npm: [html-entities](https://www.npmjs.com/package/html-entities) package.
* npm: [js-string-escape](https://www.npmjs.com/package/js-string-escape) package.
* Common Weakness Enumeration: [CWE-116](https://cwe.mitre.org/data/definitions/116.html).
* Common Weakness Enumeration: [CWE-20](https://cwe.mitre.org/data/definitions/20.html).