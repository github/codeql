# Command built from user-controlled sources

```
ID: go/command-injection
Kind: path-problem
Severity: error
Precision: high
Tags: security external/cwe/cwe-078

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql-go/tree/main/ql/src/Security/CWE-078/CommandInjection.ql)

If a system command invocation is built from user-provided data without sufficient sanitization, a malicious user may be able to run commands to exfiltrate data or compromise the system.


## Recommendation
If possible, use hard-coded string literals to specify the command to run. Instead of interpreting user input directly as command names, examine the input and then choose among hard-coded string literals.

If this is not possible, then add sanitization code to verify that the user input is safe before using it.


## Example
In the following example, assume the function `handler` is an HTTP request handler in a web application, whose parameter `req` contains the request object:


```go
package main

import (
	"net/http"
	"os/exec"
)

func handler(req *http.Request) {
	cmdName := req.URL.Query()["cmd"][0]
	cmd := exec.Command(cmdName)
	cmd.Run()
}

```
The handler extracts the name of a system command from the request object, and then runs it without any further checks, which can cause a command-injection vulnerability.


## References
* OWASP: [Command Injection](https://www.owasp.org/index.php/Command_Injection).
* Common Weakness Enumeration: [CWE-78](https://cwe.mitre.org/data/definitions/78.html).