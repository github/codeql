# Code injection

```
ID: js/code-injection
Kind: path-problem
Severity: error
Precision: high
Tags: security external/cwe/cwe-094 external/cwe/cwe-079 external/cwe/cwe-116

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/javascript/ql/src/Security/CWE-094/CodeInjection.ql)

Directly evaluating user input (for example, an HTTP request parameter) as code without properly sanitizing the input first allows an attacker arbitrary code execution. This can occur when user input is treated as JavaScript, or passed to a framework which interprets it as an expression to be evaluated. Examples include AngularJS expressions or JQuery selectors.


## Recommendation
Avoid including user input in any expression which may be dynamically evaluated. If user input must be included, use context-specific escaping before including it. It is important that the correct escaping is used for the type of evaluation that will occur.


## Example
The following example shows part of the page URL being evaluated as JavaScript code. This allows an attacker to provide JavaScript within the URL. If an attacker can persuade a user to click on a link to such a URL, the attacker can evaluate arbitrary JavaScript in the browser of the user to, for example, steal cookies containing session information.


```javascript
eval(document.location.href.substring(document.location.href.indexOf("default=")+8))

```

## References
* OWASP: [Code Injection](https://www.owasp.org/index.php/Code_Injection).
* Wikipedia: [Code Injection](https://en.wikipedia.org/wiki/Code_injection).
* Common Weakness Enumeration: [CWE-94](https://cwe.mitre.org/data/definitions/94.html).
* Common Weakness Enumeration: [CWE-79](https://cwe.mitre.org/data/definitions/79.html).
* Common Weakness Enumeration: [CWE-116](https://cwe.mitre.org/data/definitions/116.html).