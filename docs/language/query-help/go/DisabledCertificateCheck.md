# Disabled TLS certificate check

```
ID: go/disabled-certificate-check
Kind: problem
Severity: warning
Precision: high
Tags: security external/cwe/cwe-295

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql-go/tree/main/ql/src/Security/CWE-295/DisabledCertificateCheck.ql)

The field `InsecureSkipVerify` controls whether a TLS client verifies the server's certificate chain and host name. If set to `true`, the client will accept any certificate and any host name in that certificate, making it susceptible to man-in-the-middle attacks.


## Recommendation
Do not set `InsecureSkipVerify` to `true` except in tests.


## Example
The following code snippet shows a function that performs an HTTP request over TLS with certificate verification disabled:


```go
package main

import (
	"crypto/tls"
	"net/http"
)

func doAuthReq(authReq *http.Request) *http.Response {
	tr := &http.Transport{
		TLSClientConfig: &tls.Config{InsecureSkipVerify: true},
	}
	client := &http.Client{Transport: tr}
	res, _ := client.Do(authReq)
	return res
}

```
While this is acceptable in a test, it should not be used in production code. Instead, certificates should be configured such that verification can be performed.


## References
* Package tls: [Config](https://golang.org/pkg/crypto/tls/#Config).
* SSL.com: [Browsers and Certificate Validation](https://www.ssl.com/article/browsers-and-certificate-validation/).
* Common Weakness Enumeration: [CWE-295](https://cwe.mitre.org/data/definitions/295.html).