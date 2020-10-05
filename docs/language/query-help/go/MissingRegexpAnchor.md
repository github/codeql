# Missing regular expression anchor

```
ID: go/regex/missing-regexp-anchor
Kind: problem
Severity: warning
Precision: high
Tags: correctness security external/cwe/cwe-20

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql-go/tree/main/ql/src/Security/CWE-020/MissingRegexpAnchor.ql)

Sanitizing untrusted input with regular expressions is a common technique. However, it is error-prone to match untrusted input against regular expressions without anchors such as `^` or `$`. Malicious input can bypass such security checks by embedding one of the allowed patterns in an unexpected location.

Even if the matching is not done in a security-critical context, it may still cause undesirable behavior when the regular expression accidentally matches.


## Recommendation
Use anchors to ensure that regular expressions match at the expected locations.


## Example
The following example code checks that a URL redirection will reach the `example.com` domain, or one of its subdomains, and not some malicious site.


```go
package main

import (
	"errors"
	"net/http"
	"regexp"
)

func checkRedirect2(req *http.Request, via []*http.Request) error {
	// BAD: the host of `req.URL` may be controlled by an attacker
	re := "https?://www\\.example\\.com/"
	if matched, _ := regexp.MatchString(re, req.URL.String()); matched {
		return nil
	}
	return errors.New("Invalid redirect")
}

```
The check with the regular expression match is, however, easy to bypass. For example, the string `http://example.com/` can be embedded in the query string component: `http://evil-example.net/?x=http://example.com/`.

Address these shortcomings by using anchors in the regular expression instead:


```go
package main

import (
	"errors"
	"net/http"
	"regexp"
)

func checkRedirect2Good(req *http.Request, via []*http.Request) error {
	// GOOD: the host of `req.URL` cannot be controlled by an attacker
	re := "^https?://www\\.example\\.com/"
	if matched, _ := regexp.MatchString(re, req.URL.String()); matched {
		return nil
	}
	return errors.New("Invalid redirect")
}

```
A related mistake is to write a regular expression with multiple alternatives, but to only anchor one of the alternatives. As an example, the regular expression `^www\.example\.com|beta\.example\.com` will match the host `evil.beta.example.com` because the regular expression is parsed as `(^www\.example\.com)|(beta\.example\.com)/`, so the second alternative `beta\.example\.com` is not anchored at the beginning of the string.


## References
* OWASP: [SSRF](https://www.owasp.org/index.php/Server_Side_Request_Forgery)
* OWASP: [Unvalidated Redirects and Forwards Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Unvalidated_Redirects_and_Forwards_Cheat_Sheet.html).
* Common Weakness Enumeration: [CWE-20](https://cwe.mitre.org/data/definitions/20.html).