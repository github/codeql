# Bad redirect check

```
ID: go/bad-redirect-check
Kind: path-problem
Severity: error
Precision: high
Tags: security external/cwe/cwe-601

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql-go/tree/main/ql/src/Security/CWE-601/BadRedirectCheck.ql)

Redirect URLs should be checked to ensure that user input cannot cause a site to redirect to arbitrary domains. This is often done with a check that the redirect URL begins with a slash, which most of the time is an absolute redirect on the same host. However, browsers interpret URLs beginning with `//` or `/\` as absolute URLs. For example, a redirect to `//lgtm.com` will redirect to `https://lgtm.com`. Thus, redirect checks must also check the second character of redirect URLs.


## Recommendation
Also disallow redirect URLs starting with `//` or `/\`.


## Example
The following function validates a (presumably untrusted) redirect URL `redir`. If it does not begin with `/`, the harmless placeholder redirect URL `/` is returned to prevent an open redirect; otherwise `redir` itself is returned.


```go
package main

func sanitizeUrl(redir string) string {
	if len(redir) > 0 && redir[0] == '/' {
		return redir
	}
	return "/"
}

```
While this check provides partial protection, it should be extended to cover `//` and `/\` as well:


```go
package main

func sanitizeUrl1(redir string) string {
	if len(redir) > 1 && redir[0] == '/' && redir[1] != '/' && redir[1] != '\\' {
		return redir
	}
	return "/"
}

```

## References
* OWASP: [ XSS Unvalidated Redirects and Forwards Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Unvalidated_Redirects_and_Forwards_Cheat_Sheet.html#validating-urls).
* Common Weakness Enumeration: [CWE-601](https://cwe.mitre.org/data/definitions/601.html).