# Use of insecure HostKeyCallback implementation

```
ID: go/insecure-hostkeycallback
Kind: path-problem
Severity: warning
Precision: high
Tags: security

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql-go/tree/main/ql/src/Security/CWE-322/InsecureHostKeyCallback.ql)

The `ClientConfig` specifying the configuration for establishing a SSH connection has a field `HostKeyCallback` that must be initialized with a function that validates the host key returned by the server.

Not properly verifying the host key returned by a server provides attackers with an opportunity to perform a Machine-in-the-Middle (MitM) attack. A successful attack can compromise the confidentiality and integrity of the information communicated with the server.

The `ssh` package provides the predefined callback `InsecureIgnoreHostKey` that can be used during development and testing. It accepts any provided host key. This callback, or a semantically similar callback, should not be used in production code.


## Recommendation
The `HostKeyCallback` field of `ClientConfig` should be initialized with a function that validates a host key against an allow list. If a key is not on a predefined allow list, the connection must be terminated and the failed security operation should be logged.

When the allow list contains only a single host key then the function `FixedHostKey` can be used.


## Example
The following example shows the use of `InsecureIgnoreHostKey` and an insecure host key callback implemention commonly used in non-production code.


```go
package main

import (
	"golang.org/x/crypto/ssh"
	"net"
)

func main() {}

func insecureIgnoreHostKey() {
	_ = &ssh.ClientConfig{
		User:            "username",
		Auth:            []ssh.AuthMethod{nil},
		HostKeyCallback: ssh.InsecureIgnoreHostKey(),
	}
}

func insecureHostKeyCallback() {
	_ = &ssh.ClientConfig{
		User: "username",
		Auth: []ssh.AuthMethod{nil},
		HostKeyCallback: ssh.HostKeyCallback(
			func(hostname string, remote net.Addr, key ssh.PublicKey) error {
				return nil
			}),
	}
}

```
The next example shows a secure implementation using the `FixedHostKey` that implements an allow-list.


```go
package main

import (
	"golang.org/x/crypto/ssh"
	"io/ioutil"
)

func main() {}

func secureHostKeyCallback() {
	publicKeyBytes, _ := ioutil.ReadFile("allowed_hostkey.pub")
	publicKey, _ := ssh.ParsePublicKey(publicKeyBytes)

	_ = &ssh.ClientConfig{
		User:            "username",
		Auth:            []ssh.AuthMethod{nil},
		HostKeyCallback: ssh.FixedHostKey(publicKey),
	}
}

```

## References
* Go Dev: [package ssh](https://pkg.go.dev/golang.org/x/crypto/ssh?tab=doc).