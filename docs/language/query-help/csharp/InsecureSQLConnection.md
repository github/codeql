# Insecure SQL connection

```
ID: cs/insecure-sql-connection
Kind: path-problem
Severity: error
Precision: medium
Tags: security external/cwe/cwe-327

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/csharp/ql/src/Security%20Features/CWE-327/InsecureSQLConnection.ql)

SQL Server connections where the client is not enforcing the encryption in transit are susceptible to multiple attacks, including a man-in-the-middle, that would potentially compromise the user credentials and/or the TDS session.


## Recommendation
Ensure that the client code enforces the `Encrypt` option by setting it to `true` in the connection string.


## Example
The following example shows a SQL connection string that is not explicitly enabling the `Encrypt` setting to force encryption.


```csharp
using System.Data.SqlClient;

// BAD, Encrypt not specified
string connectString =
    "Server=1.2.3.4;Database=Anything;Integrated Security=true;";
SqlConnectionStringBuilder builder = new SqlConnectionStringBuilder(connectString);
var conn = new SqlConnection(builder.ConnectionString);
```
The following example shows a SQL connection string that is explicitly enabling the `Encrypt` setting to force encryption in transit.


```csharp
using System.Data.SqlClient;

string connectString =
    "Server=1.2.3.4;Database=Anything;Integrated Security=true;;Encrypt=true;";
SqlConnectionStringBuilder builder = new SqlConnectionStringBuilder(connectString);
var conn = new SqlConnection(builder.ConnectionString);
```

## References
* Microsoft, SQL Protocols blog: [Selectively using secure connection to SQL Server](https://blogs.msdn.microsoft.com/sql_protocols/2009/10/19/selectively-using-secure-connection-to-sql-server/).
* Microsoft: [SqlConnection.ConnectionString Property](https://msdn.microsoft.com/en-us/library/system.data.sqlclient.sqlconnection.connectionstring(v=vs.110).aspx).
* Microsoft: [Using Connection String Keywords with SQL Server Native Client](https://msdn.microsoft.com/en-us/library/ms130822.aspx).
* Microsoft: [Setting the connection properties](https://msdn.microsoft.com/en-us/library/ms378988(v=sql.110).aspx).
* Common Weakness Enumeration: [CWE-327](https://cwe.mitre.org/data/definitions/327.html).