# Uncontrolled data used in path expression

```
ID: go/path-injection
Kind: path-problem
Severity: error
Precision: high
Tags: security external/cwe/cwe-022 external/cwe/cwe-023 external/cwe/cwe-036 external/cwe/cwe-073 external/cwe/cwe-099

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql-go/tree/main/ql/src/Security/CWE-022/TaintedPath.ql)

Accessing files using paths constructed from user-controlled data can allow an attacker to access unexpected resources. This can result in sensitive information being revealed or deleted, or an attacker being able to influence behavior by modifying unexpected files.


## Recommendation
Validate user input before using it to construct a file path, either using an off-the-shelf library or by performing custom validation.

Ideally, follow these rules:

* Do not allow more than a single "." character.
* Do not allow directory separators such as "/" or "\" (depending on the file system).
* Do not rely on simply replacing problematic sequences such as "../". For example, after applying this filter to ".../...//", the resulting string would still be "../".
* Use an allowlist of known good patterns.

## Example
In the first example, a file name is read from an HTTP request and then used to access a file. However, a malicious user could enter a file name which is an absolute path, such as "/etc/passwd".

In the second example, it appears that the user is restricted to opening a file within the `"user"` home directory. However, a malicious user could enter a file name containing special characters. For example, the string `"../../etc/passwd"` will result in the code reading the file located at "/home/user/../../etc/passwd", which is the system's password file. This file would then be sent back to the user, giving them access to password information.


```go
package main

import (
	"io/ioutil"
	"net/http"
	"path/filepath"
)

func handler(w http.ResponseWriter, r *http.Request) {
	path := r.URL.Query()["path"][0]

	// BAD: This could read any file on the file system
	data, _ := ioutil.ReadFile(path)
	w.Write(data)

	// BAD: This could still read any file on the file system
	data, _ = ioutil.ReadFile(filepath.Join("/home/user/", path))
	w.Write(data)
}

```

## References
* OWASP: [Path Traversal](https://www.owasp.org/index.php/Path_traversal).
* Common Weakness Enumeration: [CWE-22](https://cwe.mitre.org/data/definitions/22.html).
* Common Weakness Enumeration: [CWE-23](https://cwe.mitre.org/data/definitions/23.html).
* Common Weakness Enumeration: [CWE-36](https://cwe.mitre.org/data/definitions/36.html).
* Common Weakness Enumeration: [CWE-73](https://cwe.mitre.org/data/definitions/73.html).
* Common Weakness Enumeration: [CWE-99](https://cwe.mitre.org/data/definitions/99.html).