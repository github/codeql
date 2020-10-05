# Potentially unsafe quoting

```
ID: go/unsafe-quoting
Kind: path-problem
Severity: warning
Precision: high
Tags: correctness security external/cwe/cwe-078 external/cwe/cwe-089 external/cwe/cwe-094

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql-go/tree/main/ql/src/Security/CWE-089/StringBreak.ql)

Code that constructs a string containing a quoted substring needs to ensure that any user-provided data embedded in between the quotes does not itself contain a quote. Otherwise the embedded data could (accidentally or intentionally) change the structure of the overall string by terminating the quoted substring early, with potentially severe consequences. If, for example, the string is later interpreted as an operating-system command or database query, a malicious attacker may be able to craft input data that enables a command injection or SQL injection attack.


## Recommendation
Sanitize the embedded data appropriately to ensure quotes are escaped, or use an API that does not rely on manually constructing quoted substrings.


## Example
In the following example, assume that `version` is an object from an untrusted source. The code snippet first uses `json.Marshal` to serialize this object into a string, and then embeds it into a SQL query built using the Squirrel library.


```go
package main

import (
	"encoding/json"
	"fmt"
	sq "github.com/Masterminds/squirrel"
)

func save(id string, version interface{}) {
	versionJSON, _ := json.Marshal(version)
	sq.StatementBuilder.
		Insert("resources").
		Columns("resource_id", "version_md5").
		Values(id, sq.Expr(fmt.Sprintf("md5('%s')", versionJSON))).
		Exec()
}

```
Note that while Squirrel provides a structured API for building SQL queries that mitigates against common causes of SQL injection vulnerabilities, this code is still vulnerable: if the JSON-encoded representation of `version` contains a single quote, this will prematurely close the surrounding string, changing the structure of the SQL expression being constructed. This could be exploited to mount a SQL injection attack.

To fix this vulnerability, use Squirrel's placeholder syntax, which avoids the need to explicitly construct a quoted string.


```go
package main

import (
	"encoding/json"
	sq "github.com/Masterminds/squirrel"
)

func saveGood(id string, version interface{}) {
	versionJSON, _ := json.Marshal(version)
	sq.StatementBuilder.
		Insert("resources").
		Columns("resource_id", "version_md5").
		Values(id, sq.Expr("md5(?)", versionJSON)).
		Exec()
}

```

## References
* Wikipedia: [SQL injection](https://en.wikipedia.org/wiki/SQL_injection).
* OWASP: [Command Injection](https://www.owasp.org/index.php/Command_Injection).
* Common Weakness Enumeration: [CWE-78](https://cwe.mitre.org/data/definitions/78.html).
* Common Weakness Enumeration: [CWE-89](https://cwe.mitre.org/data/definitions/89.html).
* Common Weakness Enumeration: [CWE-94](https://cwe.mitre.org/data/definitions/94.html).