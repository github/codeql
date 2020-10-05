# Information exposure through transmitted data

```
ID: cs/sensitive-data-transmission
Kind: path-problem
Severity: error
Precision: high
Tags: security external/cwe/cwe-201

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/csharp/ql/src/Security%20Features/CWE-201/ExposureInTransmittedData.ql)

Transmitting sensitive data to the user is a potential security risk. Always ensure that transmitted data is intended for the user. For example, passwords and the contents of database exceptions are generally not appropriate to send to the user, as they reveal information that could be abused or exploited.


## Recommendation
Avoid transmitting passwords or exceptions to the user. Instead, create a more user-friendly message that does not contain potentially sensitive information. Technical errors should be written to a log file.


## Example
The following example shows the user password being sent back to the user.


```csharp
public class Handler : IHttpHandler
{

    public void ProcessRequest(HttpContext ctx)
    {
        try
        {
       ...
    }
        catch (AuthenticationFailure ex)
        {
            ctx.Response.Write("Invalid password: " + password);
        }
    }
}

```
The following example shows a database exception being sent to the user. Exceptions can often contain unnecessary technical or sensitive information that should not be seen by the user.


```csharp
public class Handler : IHttpHandler
{

    public void ProcessRequest(HttpContext ctx)
    {
        try
        {
       ...
    }
        catch (DbException ex)
        {
            ctx.Response.Write("Database error: " + ex.Message);
        }
    }
}

```

## References
* OWASP: [Sensitive Data Exposure](https://www.owasp.org/index.php/Top_10_2013-A6-Sensitive_Data_Exposure).
* Common Weakness Enumeration: [CWE-201](https://cwe.mitre.org/data/definitions/201.html).