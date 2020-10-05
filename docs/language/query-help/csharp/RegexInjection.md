# Regular expression injection

```
ID: cs/regex-injection
Kind: path-problem
Severity: error
Precision: high
Tags: security external/cwe/cwe-730 external/cwe/cwe-400

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/csharp/ql/src/Security%20Features/CWE-730/RegexInjection.ql)

Constructing a regular expression with unsanitized user input is dangerous as a malicious user may be able to modify the meaning of the expression. In particular, such a user may be able to provide a regular expression fragment that takes exponential time in the worst case, and use that to perform a Denial of Service attack.


## Recommendation
For user input that is intended to be referenced as a string literal in a regular expression, use the `Regex.Escape` method to escape any special characters. If the regular expression is intended to be configurable by the user, then a timeout should be used to avoid Denial of Service attacks. For C# applications, a timeout can be provided to the `Regex` constructor. Alternatively, apply a global timeout by setting the `REGEX_DEFAULT_MATCH_TIMEOUT` application domain property, using the `AppDomain.SetData` method.


## Example
The following example shows a HTTP request parameter that is used as a regular expression, and matched against another request parameter.

In the first case, the regular expression is used without a timeout, and the user-provided regex is not escaped. If a malicious user provides a regex that has exponential worst case performance, then this could lead to a Denial of Service.

In the second case, the user input is escaped using `Regex.Escape` before being included in the regular expression. This ensures that the user cannot insert characters which have a special meaning in regular expressions.


```csharp
using System;
using System.Web;
using System.Text.RegularExpressions;

public class RegexInjectionHandler : IHttpHandler
{

    public void ProcessRequest(HttpContext ctx)
    {
        string name = ctx.Request.QueryString["name"];
        string userInput = ctx.Request.QueryString["userInput"];

        // BAD: Unsanitized user input is used to construct a regular expression
        new Regex("^" + name + "=.*$").Match(userInput);

        // GOOD: User input is sanitized before constructing the regex
        string safeName = Regex.Escape(name);
        new Regex("^" + safeName + "=.*$").Match(userInput);
    }
}

```

## References
* OWASP: [Regular expression Denial of Service - ReDoS](https://www.owasp.org/index.php/Regular_expression_Denial_of_Service_-_ReDoS).
* Wikipedia: [ReDoS](https://en.wikipedia.org/wiki/ReDoS).
* Common Weakness Enumeration: [CWE-730](https://cwe.mitre.org/data/definitions/730.html).
* Common Weakness Enumeration: [CWE-400](https://cwe.mitre.org/data/definitions/400.html).