# Reflected cross-site scripting

```
ID: go/reflected-xss
Kind: path-problem
Severity: error
Precision: high
Tags: security external/cwe/cwe-079 external/cwe/cwe-116

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql-go/tree/main/ql/src/Security/CWE-079/ReflectedXss.ql)

Directly writing user input (for example, an HTTP request parameter) to an HTTP response without properly sanitizing the input first, allows for a cross-site scripting vulnerability.

This kind of vulnerability is also called *reflected* cross-site scripting, to distinguish it from other types of cross-site scripting.


## Recommendation
To guard against cross-site scripting, consider using contextual output encoding/escaping before writing user input to the response, or one of the other solutions that are mentioned in the references.


## Example
The following example code writes part of an HTTP request (which is controlled by the user) directly to the response. This leaves the website vulnerable to cross-site scripting.


```go
package main

import (
	"fmt"
	"net/http"
)

func serve() {
	http.HandleFunc("/user", func(w http.ResponseWriter, r *http.Request) {
		r.ParseForm()
		username := r.Form.Get("username")
		if !isValidUsername(username) {
			// BAD: a request parameter is incorporated without validation into the response
			fmt.Fprintf(w, "%q is an unknown user", username)
		} else {
			// TODO: do something exciting
		}
	})
	http.ListenAndServe(":80", nil)
}

```
Sanitizing the user-controlled data prevents the vulnerability:


```go
package main

import (
	"fmt"
	"html"
	"net/http"
)

func serve1() {
	http.HandleFunc("/user", func(w http.ResponseWriter, r *http.Request) {
		r.ParseForm()
		username := r.Form.Get("username")
		if !isValidUsername(username) {
			// GOOD: a request parameter is escaped before being put into the response
			fmt.Fprintf(w, "%q is an unknown user", html.EscapeString(username))
		} else {
			// TODO: do something exciting
		}
	})
	http.ListenAndServe(":80", nil)
}

```

## References
* OWASP: [XSS (Cross Site Scripting) Prevention Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Cross_Site_Scripting_Prevention_Cheat_Sheet.html).
* OWASP [Types of Cross-Site Scripting](https://www.owasp.org/index.php/Types_of_Cross-Site_Scripting).
* Wikipedia: [Cross-site scripting](http://en.wikipedia.org/wiki/Cross-site_scripting).
* Common Weakness Enumeration: [CWE-79](https://cwe.mitre.org/data/definitions/79.html).
* Common Weakness Enumeration: [CWE-116](https://cwe.mitre.org/data/definitions/116.html).