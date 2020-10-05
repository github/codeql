# SQL query built from user-controlled sources

```
ID: py/sql-injection
Kind: path-problem
Severity: error
Precision: high
Tags: security external/cwe/cwe-089 external/owasp/owasp-a1

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/python/ql/src/Security/CWE-089/SqlInjection.ql)

If a database query (such as a SQL or NoSQL query) is built from user-provided data without sufficient sanitization, a user may be able to run malicious database queries.


## Recommendation
Most database connector libraries offer a way of safely embedding untrusted data into a query by means of query parameters or prepared statements.


## Example
In the following snippet, a user is fetched from the database using three different queries.

In the first case, the query string is built by directly using string formatting from a user-supplied request parameter. The parameter may include quote characters, so this code is vulnerable to a SQL injection attack.

In the second case, the user-supplied request attribute is passed to the database using query parameters. The database connector library will take care of escaping and inserting quotes as needed.

In the third case, the placeholder in the SQL string has been manually quoted. Since most databaseconnector libraries will insert their own quotes, doing so yourself will make the code vulnerable to SQL injection attacks. In this example, if `username` was `; DROP ALL TABLES -- `, the final SQL query would be `SELECT * FROM users WHERE username = ''; DROP ALL TABLES -- ''`


```python
from django.conf.urls import url
from django.db import connection


def show_user(request, username):
    with connection.cursor() as cursor:
        # BAD -- Using string formatting
        cursor.execute("SELECT * FROM users WHERE username = '%s'" % username)
        user = cursor.fetchone()

        # GOOD -- Using parameters
        cursor.execute("SELECT * FROM users WHERE username = %s", username)
        user = cursor.fetchone()

        # BAD -- Manually quoting placeholder (%s)
        cursor.execute("SELECT * FROM users WHERE username = '%s'", username)
        user = cursor.fetchone()

urlpatterns = [url(r'^users/(?P<username>[^/]+)$', show_user)]

```

## References
* Wikipedia: [SQL injection](https://en.wikipedia.org/wiki/SQL_injection).
* OWASP: [SQL Injection Prevention Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/SQL_Injection_Prevention_Cheat_Sheet.html).
* Common Weakness Enumeration: [CWE-89](https://cwe.mitre.org/data/definitions/89.html).