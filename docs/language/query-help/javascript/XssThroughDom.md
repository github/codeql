# DOM text reinterpreted as HTML

```
ID: js/xss-through-dom
Kind: path-problem
Severity: warning
Precision: high
Tags: security external/cwe/cwe-079 external/cwe/cwe-116

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/javascript/ql/src/Security/CWE-079/XssThroughDom.ql)

Extracting text from a DOM node and interpreting it as HTML can lead to a cross-site scripting vulnerability.

A webpage with this vulnerability reads text from the DOM, and afterwards adds the text as HTML to the DOM. Using text from the DOM as HTML effectively unescapes the text, and thereby invalidates any escaping done on the text. If an attacker is able to control the safe sanitized text, then this vulnerability can be exploited to perform a cross-site scripting attack.


## Recommendation
To guard against cross-site scripting, consider using contextual output encoding/escaping before writing text to the page, or one of the other solutions that are mentioned in the References section below.


## Example
The following example shows a webpage using a `data-target` attribute to select and manipulate a DOM element using the JQuery library. In the example, the `data-target` attribute is read into the `target` variable, and the `$` function is then supposed to use the `target` variable as a CSS selector to determine which element should be manipulated.


```javascript
$("button").click(function () {
    var target = $(this).attr("data-target");
    $(target).hide();
});

```
However, if an attacker can control the `data-target` attribute, then the value of `target` can be used to cause the `$` function to execute arbitary JavaScript.

The above vulnerability can be fixed by using `$.find` instead of `$`. The `$.find` function will only interpret `target` as a CSS selector and never as HTML, thereby preventing an XSS attack.


```javascript
$("button").click(function () {
    var target = $(this).attr("data-target");
	$.find(target).hide();
});

```

## References
* OWASP: [DOM based XSS Prevention Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/DOM_based_XSS_Prevention_Cheat_Sheet.html).
* OWASP: [XSS (Cross Site Scripting) Prevention Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Cross_Site_Scripting_Prevention_Cheat_Sheet.html).
* OWASP [DOM Based XSS](https://owasp.org/www-community/attacks/DOM_Based_XSS).
* OWASP [Types of Cross-Site Scripting](https://owasp.org/www-community/Types_of_Cross-Site_Scripting).
* Wikipedia: [Cross-site scripting](http://en.wikipedia.org/wiki/Cross-site_scripting).
* Common Weakness Enumeration: [CWE-79](https://cwe.mitre.org/data/definitions/79.html).
* Common Weakness Enumeration: [CWE-116](https://cwe.mitre.org/data/definitions/116.html).