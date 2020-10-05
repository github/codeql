# Insecure URL whitelist

```
ID: js/angular/insecure-url-whitelist
Kind: problem
Severity: warning
Precision: very-high
Tags: security frameworks/angularjs external/cwe/cwe-183 external/cwe/cwe-625

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/javascript/ql/src/AngularJS/InsecureUrlWhitelist.ql)

AngularJS uses filters to ensure that the URLs used for sourcing AngularJS templates and other script-running URLs are safe. One such filter is a whitelist of URL patterns to allow.

A URL pattern that is too permissive can cause security vulnerabilities.


## Recommendation
Make the whitelist URL patterns as restrictive as possible.


## Example
The following example shows an AngularJS application with whitelist URL patterns that all are too permissive.


```javascript
angular.module('myApp', [])
    .config(function($sceDelegateProvider) {
        $sceDelegateProvider.resourceUrlWhitelist([
            "*://example.org/*", // BAD
            "https://**.example.com/*", // BAD
            "https://example.**", // BAD
            "https://example.*" // BAD
        ]);
    });

```
This is problematic, since the four patterns match the following malicious URLs, respectively:

* `javascript://example.org/a%0A%0Dalert(1)` (`%0A%0D` is a linebreak)
* `https://evil.com/?ignore=://example.com/a`
* `https://example.evil.com`
* `https://example.evilTld`

## References
* OWASP/Google presentation: [Securing AngularJS Applications](https://www.owasp.org/images/6/6e/Benelus_day_20161125_S_Lekies_Securing_AngularJS_Applications.pdf)
* AngularJS Developer Guide: [Format of items in resourceUrlWhitelist/Blacklist](https://docs.angularjs.org/api/ng/service/$sce#resourceUrlPatternItem).
* Common Weakness Enumeration: [CWE-183](https://cwe.mitre.org/data/definitions/183.html).
* Common Weakness Enumeration: [CWE-625](https://cwe.mitre.org/data/definitions/625.html).