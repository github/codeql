# Uncontrolled format string

```
ID: cs/uncontrolled-format-string
Kind: path-problem
Severity: error
Precision: high
Tags: security external/cwe/cwe-134

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/csharp/ql/src/Security%20Features/CWE-134/UncontrolledFormatString.ql)

Passing untrusted format strings to `String.Format` can throw exceptions and cause a denial of service. For example, if the format string references a missing argument, or an argument of the wrong type, then `System.FormatException` is thrown.


## Recommendation
Use a string literal for the format string to prevent the possibility of data flow from an untrusted source. This also helps to prevent errors where the arguments to `String.Format` do not match the format string.

If the format string cannot be constant, ensure that it comes from a secure data source or is compiled into the source code.


## Example
In this example, the format string is read from an HTTP request, which could cause the application to crash.


```csharp
using System.Web;

public class HttpHandler : IHttpHandler
{
    string Surname, Forenames, FormattedName;

    public void ProcessRequest(HttpContext ctx)
    {
        string format = ctx.Request.QueryString["nameformat"];

        // BAD: Uncontrolled format string.
        FormattedName = string.Format(format, Surname, Forenames);
    }
}

```

## References
* OWASP: [Format string attack](https://www.owasp.org/index.php/Format_string_attack).
* Microsoft docs: [String.Format Method](https://docs.microsoft.com/en-us/dotnet/api/system.string.format)
* Common Weakness Enumeration: [CWE-134](https://cwe.mitre.org/data/definitions/134.html).