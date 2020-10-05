# Database query built from user-controlled sources

```
ID: go/sql-injection
Kind: path-problem
Severity: error
Precision: high
Tags: security external/cwe/cwe-089

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql-go/tree/main/ql/src/Security/CWE-089/SqlInjection.ql)

If a database query (such as an SQL or NoSQL query) is built from user-provided data without sufficient sanitization, a malicious user may be able to run commands that exfiltrate, tamper with, or destroy data stored in the database.


## Recommendation
Most database connector libraries offer a way of safely embedding untrusted data into a query by means of query parameters or prepared statements. Use these features rather than building queries by string concatenation.


## Example
In the following example, assume the function `handler` is an HTTP request handler in a web application, whose parameter `req` contains the request object:


```go
package main

import (
	"database/sql"
	"fmt"
	"net/http"
)

func handler(db *sql.DB, req *http.Request) {
	q := fmt.Sprintf("SELECT ITEM,PRICE FROM PRODUCT WHERE ITEM_CATEGORY='%s' ORDER BY PRICE",
		req.URL.Query()["category"])
	db.Query(q)
}

```
The handler constructs an SQL query involving user input taken from the request object unsafely using `fmt.Sprintf` to embed a request parameter directly into the query string `q`. The parameter may include quote characters, allowing a malicious user to terminate the string literal into which the parameter is embedded and add arbitrary SQL code after it.

Instead, the untrusted query parameter should be safely embedded using placeholder parameters:


```go
package main

import (
	"database/sql"
	"net/http"
)

func handlerGood(db *sql.DB, req *http.Request) {
	q := "SELECT ITEM,PRICE FROM PRODUCT WHERE ITEM_CATEGORY='?' ORDER BY PRICE"
	db.Query(q, req.URL.Query()["category"])
}

```

## References
* Wikipedia: [SQL injection](https://en.wikipedia.org/wiki/SQL_injection).
* Common Weakness Enumeration: [CWE-89](https://cwe.mitre.org/data/definitions/89.html).