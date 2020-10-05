# Resource injection

```
ID: cs/resource-injection
Kind: path-problem
Severity: error
Precision: high
Tags: security external/cwe/cwe-099

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/csharp/ql/src/Security%20Features/CWE-099/ResourceInjection.ql)

If a resource descriptor is built using string concatenation, and the components of the concatenation include user input, a user may be able to hijack the resource which is loaded.


## Recommendation
If user input must be included in a resource descriptor, it should be escaped to avoid a malicious user providing special characters that change the meaning of the descriptor. If possible, use an existing library to either escape or construct the resource.

For data connections within sub namespaces of `System.Data`, a connection builder class is provided. For example, a connection string which is to be passed to `System.Data.SqlClient.SqlConnection` can be constructed safely using an instance of `System.Data.SqlClient.SqlConnectionStringBuilder`.


## Example
In the following examples, the code accepts a user name from the user, which it uses to create a connection string for an SQL database.

The first example concatenates the unvalidated and unencoded user input directly into the connection string. A malicious user could provide special characters to change the meaning of the connection string, and connect to a completely different server.

The second example uses the `SqlConnectionStringBuilder` to construct the connection string and therefore prevents a malicious user modifying the meaning of the connection string.


```csharp
using System.Data.SqlClient;
using System.Web;

public class ResourceInjectionHandler : IHttpHandler
{
    public void ProcessRequest(HttpContext ctx)
    {
        string userName = ctx.Request.QueryString["userName"];

        // BAD: Direct use of user input in a connection string passed to SqlConnection
        string connectionString = "server=(local);user id=" + userName + ";password= pass;";
        SqlConnection sqlConnectionBad = new SqlConnection(connectionString);

        // GOOD: Use SqlConnectionStringBuilder to safely include user input in a connection string
        SqlConnectionStringBuilder builder = new SqlConnectionStringBuilder();
        builder["Data Source"] = "(local)";
        builder["integrated Security"] = true;
        builder["user id"] = userName;
        SqlConnection sqlConnectionGood = new SqlConnection(builder.ConnectionString);
    }
}

```

## References
* OWASP: [Resource Injection](https://www.owasp.org/index.php/Resource_Injection).
* MSDN: [Building Connection Strings](https://msdn.microsoft.com/en-us/library/ms254947(v=vs.80).aspx).
* MSDN: [Securing Connection Strings](https://msdn.microsoft.com/en-us/library/89211k9b(VS.80).aspx).
* Common Weakness Enumeration: [CWE-99](https://cwe.mitre.org/data/definitions/99.html).