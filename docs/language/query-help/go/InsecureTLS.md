# Insecure TLS configuration

```
ID: go/insecure-tls
Kind: path-problem
Severity: warning
Precision: very-high
Tags: security external/cwe/cwe-327

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql-go/tree/main/ql/src/Security/CWE-327/InsecureTLS.ql)

The TLS (Transport Layer Security) protocol secures communications over the Internet. The protocol allows client/server applications to communicate in a way that is designed to prevent eavesdropping, tampering, or message forgery.

The current latest version is 1.3 (with the 1.2 version still being considered secure). Older versions are not deemed to be secure anymore because of various security vulnerabilities, and tht makes them unfit for use in securing your applications.

Unfortunately, many applications and websites still support deprecated SSL/TLS versions and cipher suites.


## Recommendation
Only use secure TLS versions (1.3 and 1.2) and avoid using insecure cipher suites (you can see a list here: https://golang.org/src/crypto/tls/cipher_suites.go#L81)


## Example
The following example shows a few ways how an insecure TLS configuration can be created:


```go
package main

import (
	"crypto/tls"
)

func main() {}

func insecureMinMaxTlsVersion() {
	{
		config := &tls.Config{}
		config.MinVersion = 0 // BAD: Setting the MinVersion to 0 equals to choosing the lowest supported version (i.e. SSL3.0)
	}
	{
		config := &tls.Config{}
		config.MinVersion = tls.VersionSSL30 // BAD: SSL 3.0 is a non-secure version of the protocol; it's not safe to use it as MinVersion.
	}
	{
		config := &tls.Config{}
		config.MaxVersion = tls.VersionSSL30 // BAD: SSL 3.0 is a non-secure version of the protocol; it's not safe to use it as MaxVersion.
	}
}

func insecureCipherSuites() {
	config := &tls.Config{
		CipherSuites: []uint16{
			tls.TLS_RSA_WITH_RC4_128_SHA, // BAD: TLS_RSA_WITH_RC4_128_SHA is one of the non-secure cipher suites; it's not safe to be used.
		},
	}
	_ = config
}

```
The following example shows how to create a safer TLS configuration:


```go
package main

import "crypto/tls"

func saferTLSConfig() {
	config := &tls.Config{}
	config.MinVersion = tls.VersionTLS12
	config.MaxVersion = tls.VersionTLS13
	// OR
	config.MaxVersion = 0 // GOOD: Setting MaxVersion to 0 means that the highest version available in the package will be used.
}

```

## References
* Wikipedia: [Transport Layer Security](https://en.wikipedia.org/wiki/Transport_Layer_Security)
* Mozilla: [Security/Server Side TLS](https://wiki.mozilla.org/Security/Server_Side_TLS)
* OWASP: [Transport Layer Protection Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Transport_Layer_Protection_Cheat_Sheet.html)
* Common Weakness Enumeration: [CWE-327](https://cwe.mitre.org/data/definitions/327.html).