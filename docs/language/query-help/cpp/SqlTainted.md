# Uncontrolled data in SQL query

```
ID: cpp/sql-injection
Kind: path-problem
Severity: error
Precision: high
Tags: security external/cwe/cwe-089

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/cpp/ql/src/Security/CWE/CWE-089/SqlTainted.ql)

The code passes user input as part of a SQL query without escaping special elements. It generates a SQL query using `sprintf`, with the user-supplied data directly passed as an argument to `sprintf`. This leaves the code vulnerable to attack by SQL Injection.


## Recommendation
Use a library routine to escape characters in the user-supplied string before converting it to SQL.


## Example

```c
int main(int argc, char** argv) {
  char *userName = argv[2];
  
  // BAD
  char query1[1000] = {0};
  sprintf(query1, "SELECT UID FROM USERS where name = \"%s\"", userName);
  runSql(query1);
  
  // GOOD
  char userNameSql[1000] = {0};
  encodeSqlString(userNameSql, 1000, userName); 
  char query2[1000] = {0};
  sprintf(query2, "SELECT UID FROM USERS where name = \"%s\"", userNameSql);
  runSql(query2);
}

```

## References
* Microsoft Developer Network: [SQL Injection](http://msdn.microsoft.com/en-us/library/ms161953.aspx).
* Common Weakness Enumeration: [CWE-89](https://cwe.mitre.org/data/definitions/89.html).