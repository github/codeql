# Unsafe jQuery plugin

```
ID: js/unsafe-jquery-plugin
Kind: path-problem
Severity: warning
Precision: high
Tags: security external/cwe/cwe-079 external/cwe/cwe-116 frameworks/jquery

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/javascript/ql/src/Security/CWE-079/UnsafeJQueryPlugin.ql)

Library plugins, such as those for the jQuery library, are often configurable through options provided by the clients of the plugin. Clients, however, do not know the implementation details of the plugin, so it is important to document the capabilities of each option. The documentation for the plugin options that the client is responsible for sanitizing is of particular importance. Otherwise, the plugin may write user input (for example, a URL query parameter) to a web page without properly sanitizing it first, which allows for a cross-site scripting vulnerability in the client application through dynamic HTML construction.


## Recommendation
Document all options that can lead to cross-site scripting attacks, and guard against unsafe inputs where dynamic HTML construction is not intended.


## Example
The following example shows a jQuery plugin that selects a DOM element, and copies its text content to another DOM element. The selection is performed by using the plugin option `sourceSelector` as a CSS selector.


```javascript
jQuery.fn.copyText = function(options) {
	// BAD may evaluate `options.sourceSelector` as HTML
	var source = jQuery(options.sourceSelector),
	    text = source.text();
	jQuery(this).text(text);
}

```
This is, however, not a safe plugin, since the call to `jQuery` interprets `sourceSelector` as HTML if it is a string that starts with `<`.

Instead of documenting that the client is responsible for sanitizing `sourceSelector`, the plugin can use `jQuery.find` to always interpret `sourceSelector` as a CSS selector:


```javascript
jQuery.fn.copyText = function(options) {
	// GOOD may not evaluate `options.sourceSelector` as HTML
	var source = jQuery.find(options.sourceSelector),
	    text = source.text();
	jQuery(this).text(text);
}

```

## References
* OWASP: [DOM based XSS Prevention Cheat Sheet](https://www.owasp.org/index.php/DOM_based_XSS_Prevention_Cheat_Sheet).
* OWASP: [XSS (Cross Site Scripting) Prevention Cheat Sheet](https://www.owasp.org/index.php/XSS_%28Cross_Site_Scripting%29_Prevention_Cheat_Sheet).
* OWASP [DOM Based XSS](https://www.owasp.org/index.php/DOM_Based_XSS).
* OWASP [Types of Cross-Site Scripting](https://www.owasp.org/index.php/Types_of_Cross-Site_Scripting).
* Wikipedia: [Cross-site scripting](http://en.wikipedia.org/wiki/Cross-site_scripting).
* jQuery: [Plugin creation](https://learn.jquery.com/plugins/basic-plugin-creation/).
* Bootstrap: [XSS vulnerable bootstrap plugins](https://github.com/twbs/bootstrap/pull/27047).
* Common Weakness Enumeration: [CWE-79](https://cwe.mitre.org/data/definitions/79.html).
* Common Weakness Enumeration: [CWE-116](https://cwe.mitre.org/data/definitions/116.html).