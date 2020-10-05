# Database query built from user-controlled sources

```
ID: js/sql-injection
Kind: path-problem
Severity: error
Precision: high
Tags: security external/cwe/cwe-089

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/javascript/ql/src/Security/CWE-089/SqlInjection.ql)

If a database query (such as a SQL or NoSQL query) is built from user-provided data without sufficient sanitization, a malicious user may be able to run malicious database queries.


## Recommendation
Most database connector libraries offer a way of safely embedding untrusted data into a query by means of query parameters or prepared statements.


## Example
In the following example, assume the function `handler` is an HTTP request handler in a web application, whose parameter `req` contains the request object.

The handler constructs two copies of the same SQL query involving user input taken from the request object, once unsafely using string concatenation, and once safely using query parameters.

In the first case, the query string `query1` is built by directly concatenating a user-supplied request parameter with some string literals. The parameter may include quote characters, so this code is vulnerable to a SQL injection attack.

In the second case, the parameter is embedded into the query string `query2` using query parameters. In this example, we use the API offered by the `pg` Postgres database connector library, but other libraries offer similar features. This version is immune to injection attacks.


```javascript
const app = require("express")(),
      pg = require("pg"),
      pool = new pg.Pool(config);

app.get("search", function handler(req, res) {
  // BAD: the category might have SQL special characters in it
  var query1 =
    "SELECT ITEM,PRICE FROM PRODUCT WHERE ITEM_CATEGORY='" +
    req.params.category +
    "' ORDER BY PRICE";
  pool.query(query1, [], function(err, results) {
    // process results
  });

  // GOOD: use parameters
  var query2 =
    "SELECT ITEM,PRICE FROM PRODUCT WHERE ITEM_CATEGORY=$1" + " ORDER BY PRICE";
  pool.query(query2, [req.params.category], function(err, results) {
    // process results
  });
});

```

## References
* Wikipedia: [SQL injection](https://en.wikipedia.org/wiki/SQL_injection).
* Common Weakness Enumeration: [CWE-89](https://cwe.mitre.org/data/definitions/89.html).