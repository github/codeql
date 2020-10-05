# Incomplete URL scheme check

```
ID: go/incomplete-url-scheme-check
Kind: problem
Severity: warning
Precision: high
Tags: security correctness external/cwe/cwe-020

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql-go/tree/main/ql/src/Security/CWE-020/IncompleteUrlSchemeCheck.ql)

URLs with the special scheme `javascript` can be used to encode JavaScript code to be executed when the URL is visited. While this is a powerful mechanism for creating feature-rich and responsive web applications, it is also a potential security risk: if the URL comes from an untrusted source, it might contain harmful JavaScript code. For this reason, many frameworks and libraries first check the URL scheme of any untrusted URL, and reject URLs with the `javascript` scheme.

However, the `data` and `vbscript` schemes can be used to represent executable code in a very similar way, so any validation logic that checks against `javascript`, but not against `data` and `vbscript`, is likely to be insufficient.


## Recommendation
Add checks covering both `data:` and `vbscript:`.


## Example
The following function validates a (presumably untrusted) URL `urlstr`. If its scheme is `javascript`, the harmless placeholder URL `about:blank` is returned to prevent code injection; otherwise `urlstr` itself is returned.


```go
package main

import "net/url"

func sanitizeUrl(urlstr string) string {
	u, err := url.Parse(urlstr)
	if err != nil || u.Scheme == "javascript" {
		return "about:blank"
	}
	return urlstr
}

```
While this check provides partial projection, it should be extended to cover `data` and `vbscript` as well:


```go
package main

import "net/url"

func sanitizeUrlGod(urlstr string) string {
	u, err := url.Parse(urlstr)
	if err != nil || u.Scheme == "javascript" || u.Scheme == "data" || u.Scheme == "vbscript" {
		return "about:blank"
	}
	return urlstr
}

```

## References
* WHATWG: [URL schemes](https://wiki.whatwg.org/wiki/URL_schemes).
* Common Weakness Enumeration: [CWE-20](https://cwe.mitre.org/data/definitions/20.html).