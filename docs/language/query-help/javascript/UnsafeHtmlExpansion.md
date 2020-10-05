# Unsafe expansion of self-closing HTML tag

```
ID: js/unsafe-html-expansion
Kind: problem
Severity: warning
Precision: very-high
Tags: correctness security external/cwe/cwe-079 external/cwe/cwe-116

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/javascript/ql/src/Security/CWE-116/UnsafeHtmlExpansion.ql)

Sanitizing untrusted input for HTML meta-characters is an important technique for preventing cross-site scripting attacks. But even a sanitized input can be dangerous to use if it is modified further before a browser treats it as HTML. A seemingly innocent transformation that expands a self-closing HTML tag from `<div attr="{sanitized}"/>` to `<div attr="{sanitized}"></div>` may in fact cause cross-site scripting vulnerabilities.


## Recommendation
Use a well-tested sanitization library if at all possible, and avoid modifying sanitized values further before treating them as HTML.


## Example
The following function transforms a self-closing HTML tag to a pair of open/close tags. It does so for all non-`img` and non-`area` tags, by using a regular expression with two capture groups. The first capture group corresponds to the name of the tag, and the second capture group to the content of the tag.


```javascript
function expandSelfClosingTags(html) {
	var rxhtmlTag = /<(?!img|area)(([a-z][^\w\/>]*)[^>]*)\/>/gi;
	return html.replace(rxhtmlTag, "<$1></$2>"); // BAD
}

```
While it is generally known regular expressions are ill-suited for parsing HTML, variants of this particular transformation pattern have long been considered safe.

However, the function is not safe. As an example, consider the following string:


```html
<div alt="
<x" title="/>
<img src=url404 onerror=alert(1)>"/>

```
When the above function transforms the string, it becomes a string that results in an alert when a browser treats it as HTML.


```html
<div alt="
<x" title="></x" >
<img src=url404 onerror=alert(1)>"/>

```

## References
* jQuery: [Security fixes in jQuery 3.5.0](https://blog.jquery.com/2020/04/10/jquery-3-5-0-released/)
* OWASP: [DOM based XSS Prevention Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/DOM_based_XSS_Prevention_Cheat_Sheet.html).
* OWASP: [XSS (Cross Site Scripting) Prevention Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Cross_Site_Scripting_Prevention_Cheat_Sheet.html).
* OWASP [Types of Cross-Site](https://owasp.org/www-community/Types_of_Cross-Site_Scripting).
* Wikipedia: [Cross-site scripting](http://en.wikipedia.org/wiki/Cross-site_scripting).
* Common Weakness Enumeration: [CWE-79](https://cwe.mitre.org/data/definitions/79.html).
* Common Weakness Enumeration: [CWE-116](https://cwe.mitre.org/data/definitions/116.html).