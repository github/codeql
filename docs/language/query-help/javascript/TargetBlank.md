# Potentially unsafe external link

```
ID: js/unsafe-external-link
Kind: problem
Severity: warning
Precision: very-high
Tags: maintainability security external/cwe/cwe-200 external/cwe/cwe-1022

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/javascript/ql/src/DOM/TargetBlank.ql)

HTML links that open in a new tab or window allow the target page to access the DOM of the origin page using `window.opener` unless link type `noopener` or `noreferrer` is specified. This is a potential security risk.


## Recommendation
Specify the link type by adding an attribute `rel="noopener noreferrer"`.


## Example
In the following example, a JSX element is created that corresponds to an HTML link opening the URL `http://example.com` in a new tab. Since it does not specify a link type, that page will be able to access the DOM of the origin page.


```javascript
var link = <a href="http://example.com" target="_blank">Example</a>;

```
To fix this vulnerability, add a `rel` attribute:


```javascript
var link = <a href="http://example.com" target="_blank" rel="noopener noreferrer">Example</a>;

```

## References
* Mathias Bynens: [About rel=noopener](https://mathiasbynens.github.io/rel-noopener/).
* Mozilla Developer Network: [HTML Anchor Element](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/a).
* Common Weakness Enumeration: [CWE-200](https://cwe.mitre.org/data/definitions/200.html).
* Common Weakness Enumeration: [CWE-1022](https://cwe.mitre.org/data/definitions/1022.html).