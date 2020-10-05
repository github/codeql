# Exposure of private information

```
ID: cs/exposure-of-sensitive-information
Kind: path-problem
Severity: error
Precision: high
Tags: security external/cwe/cwe-359

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/csharp/ql/src/Security%20Features/CWE-359/ExposureOfPrivateInformation.ql)

Private information that is stored in an external location may be more vulnerable because that location may not be protected by the same access controls as other parts of the system.

Examples include log files, cookies and plain text storage on disk.


## Recommendation
Ensure that private information is only stored in secure data locations.


## Example
The following example shows some private data - an address - being passed to a HTTP handler. This private information is then stored in a log file. This log file on disk may be accessible to users that do not normally have access to this private data.


```csharp
using System.Text;
using System.Web;
using System.Web.Security;

public class PrivateInformationHandler : IHttpHandler
{

    public void ProcessRequest(HttpContext ctx)
    {
        string address = ctx.Request.QueryString["Address1"];
        logger.Info("User has address: " + address);
    }
}

```

## References
* Common Weakness Enumeration: [CWE-359](https://cwe.mitre.org/data/definitions/359.html).