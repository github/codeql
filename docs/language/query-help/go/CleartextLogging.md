# Clear-text logging of sensitive information

```
ID: go/clear-text-logging
Kind: path-problem
Severity: error
Precision: high
Tags: security external/cwe/cwe-312 external/cwe/cwe-315 external/cwe/cwe-359

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql-go/tree/main/ql/src/Security/CWE-312/CleartextLogging.ql)

Sensitive information that is logged unencrypted is accessible to an attacker who gains access to the logs.


## Recommendation
Ensure that sensitive information is always encrypted or obfuscated before being logged.

In general, decrypt sensitive information only at the point where it is necessary for it to be used in cleartext.

Be aware that external processes often store the standard out and standard error streams of the application, causing logged sensitive information to be stored.


## Example
The following example code logs user credentials (in this case, their password) in plain text:


```go
package main

import (
	"log"
	"net/http"
)

func serve() {
	http.HandleFunc("/register", func(w http.ResponseWriter, r *http.Request) {
		r.ParseForm()
		user := r.Form.Get("user")
		pw := r.Form.Get("password")

		log.Printf("Registering new user %s with password %s.\n", user, pw)
	})
	http.ListenAndServe(":80", nil)
}

```
Instead, the credentials should be encrypted, obfuscated, or omitted entirely:


```go
package main

import (
	"log"
	"net/http"
)

func serve1() {
	http.HandleFunc("/register", func(w http.ResponseWriter, r *http.Request) {
		r.ParseForm()
		user := r.Form.Get("user")
		pw := r.Form.Get("password")

		log.Printf("Registering new user %s.\n", user)

		// ...
		use(pw)
	})
	http.ListenAndServe(":80", nil)
}

```

## References
* M. Dowd, J. McDonald and J. Schuhm, *The Art of Software Security Assessment*, 1st Edition, Chapter 2 - 'Common Vulnerabilities of Encryption', p. 43. Addison Wesley, 2006.
* M. Howard and D. LeBlanc, *Writing Secure Code*, 2nd Edition, Chapter 9 - 'Protecting Secret Data', p. 299. Microsoft, 2002.
* OWASP: [Password Plaintext Storage](https://www.owasp.org/index.php/Password_Plaintext_Storage).
* Common Weakness Enumeration: [CWE-312](https://cwe.mitre.org/data/definitions/312.html).
* Common Weakness Enumeration: [CWE-315](https://cwe.mitre.org/data/definitions/315.html).
* Common Weakness Enumeration: [CWE-359](https://cwe.mitre.org/data/definitions/359.html).