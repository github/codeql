# Email content injection

```
ID: go/email-injection
Kind: path-problem
Severity: error
Precision: high
Tags: security external/cwe/cwe-640

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql-go/tree/main/ql/src/Security/CWE-640/EmailInjection.ql)

Using untrusted input to construct an email can cause multiple security vulnerabilities. For instance, inclusion of an untrusted input in an email body may allow an attacker to conduct cross-site scripting (XSS) attacks, while inclusion of an HTTP header may allow a full account compromise as shown in the example below.


## Recommendation
Any data which is passed to an email subject or body must be sanitized before use.


## Example
In the following example snippet, the `host` field is user controlled.

A malicious user can send an HTTP request to the targeted website, but with a Host header that refers to their own website. This means the emails will be sent out to potential victims, originating from a server they trust, but with links leading to a malicious website.

If the email contains a password reset link, and the victim clicks the link, the secret reset token will be leaked to the attacker. Using the leaked token, the attacker can then construct the real reset link and use it to change the victim's password.


```go
package main

import (
	"net/http"
	"net/smtp"
)

func mail(w http.ResponseWriter, r *http.Request) {
	host := r.Header.Get("Host")
	token := backend.getUserSecretResetToken(email)
	body := "Click to reset password: " + host + "/" + token
	smtp.SendMail("test.test", nil, "from@from.com", nil, []byte(body))
}

```
One way to prevent this is to load the host name from a trusted configuration file instead.


```go
package main

import (
	"net/http"
	"net/smtp"
)

func mailGood(w http.ResponseWriter, r *http.Request) {
	host := config.Get("Host")
	token := backend.getUserSecretResetToken(email)
	body := "Click to reset password: " + host + "/" + token
	smtp.SendMail("test.test", nil, "from@from.com", nil, []byte(body))
}

```

## References
* OWASP: [Content Spoofing](https://owasp.org/www-community/attacks/Content_Spoofing) .
* Common Weakness Enumeration: [CWE-640](https://cwe.mitre.org/data/definitions/640.html).