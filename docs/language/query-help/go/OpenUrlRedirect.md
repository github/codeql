# Open URL redirect

```
ID: go/unvalidated-url-redirection
Kind: path-problem
Severity: warning
Precision: high
Tags: security external/cwe/cwe-601

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql-go/tree/main/ql/src/Security/CWE-601/OpenUrlRedirect.ql)

Directly incorporating user input into a URL redirect request without validating the input can facilitate phishing attacks. In these attacks, unsuspecting users can be redirected to a malicious site that looks very similar to the real site they intend to visit, but is controlled by the attacker.


## Recommendation
To guard against untrusted URL redirection, it is advisable to avoid putting user input directly into a redirect URL. Instead, maintain a list of authorized redirects on the server; then choose from that list based on the user input provided.


## Example
The following example shows an HTTP request parameter being used directly in a URL redirect without validating the input, which facilitates phishing attacks:


```go
package main

import (
	"net/http"
)

func serve() {
	http.HandleFunc("/redir", func(w http.ResponseWriter, r *http.Request) {
		r.ParseForm()
		http.Redirect(w, r, r.Form.Get("target"), 302)
	})
}

```
One way to remedy the problem is to validate the user input against a known fixed string before doing the redirection:


```go
package main

import (
	"net/http"
	"net/url"
)

func serve() {
	http.HandleFunc("/redir", func(w http.ResponseWriter, r *http.Request) {
		r.ParseForm()
		target, err := url.Parse(r.Form.Get("target"))
		if err != nil {
			// ...
		}

		if target.Hostname() == "semmle.com" {
			// GOOD: checking hostname
			http.Redirect(w, r, target.String(), 302)
		} else {
			http.WriteHeader(400)
		}
	})
}

```

## References
* OWASP: [ XSS Unvalidated Redirects and Forwards Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Unvalidated_Redirects_and_Forwards_Cheat_Sheet.html).
* Common Weakness Enumeration: [CWE-601](https://cwe.mitre.org/data/definitions/601.html).