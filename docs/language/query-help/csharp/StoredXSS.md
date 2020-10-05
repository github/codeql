# Stored cross-site scripting

```
ID: cs/web/stored-xss
Kind: path-problem
Severity: error
Precision: medium
Tags: security external/cwe/cwe-079 external/cwe/cwe-116

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/csharp/ql/src/Security%20Features/CWE-079/StoredXSS.ql)

Directly writing user input (for example, an HTTP request parameter) to a webpage, without properly sanitizing the input first, allows for a cross-site scripting vulnerability.


## Recommendation
To guard against cross-site scripting, consider using contextual output encoding/escaping before writing user input to the page, or one of the other solutions that are mentioned in the references.


## Example
The following example shows the page parameter being written directly to the server error page, leaving the website vulnerable to cross-site scripting.


```csharp
using System;
using System.Web;

public class XSSHandler : IHttpHandler
{
    public void ProcessRequest(HttpContext ctx)
    {
        ctx.Response.Write(
            "The page \"" + ctx.Request.QueryString["page"] + "\" was not found.");
    }
}

```

## References
* OWASP: [XSS (Cross Site Scripting) Prevention Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Cross_Site_Scripting_Prevention_Cheat_Sheet.html).
* Wikipedia: [Cross-site scripting](http://en.wikipedia.org/wiki/Cross-site_scripting).
* Common Weakness Enumeration: [CWE-79](https://cwe.mitre.org/data/definitions/79.html).
* Common Weakness Enumeration: [CWE-116](https://cwe.mitre.org/data/definitions/116.html).