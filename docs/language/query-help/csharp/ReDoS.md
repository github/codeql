# Denial of Service from comparison of user input against expensive regex

```
ID: cs/redos
Kind: path-problem
Severity: error
Precision: high
Tags: security external/cwe/cwe-730 external/cwe/cwe-400

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/csharp/ql/src/Security%20Features/CWE-730/ReDoS.ql)

Matching user input against a regular expression which takes exponential time in the worst case can allow a malicious user to perform a Denial of Service ("DoS") attack by crafting input that takes a long time to execute.

Most regular expression engines, including the C# standard library implementation, are designed to work with an extended regular expression syntax. Although this provides flexibility for the user, it can prevent the engine from constructing an efficient implementation of the matcher in all circumstances. In particular, the "worst case time complexity" (see the references) of certain regular expressions may be "exponential". This would allow a malicious user to provide some input which causes the regular expression to take a very long time to execute.

Typically, a regular expression is vulnerable to this attack if it applies repetition to a sub-expression which itself is repeated, or contains overlapping options. For example, `(a+)+` is vulnerable to a string such as `aaaaaaaaaaaaaaaaaaaaaaaaaaab`. More information about the precise circumstances can be found in the references.


## Recommendation
Modify the regular expression to avoid the exponential worst case time. If this is not possible, then a timeout should be used to avoid a denial of service. For C# applications, a timeout can be provided to the `Regex` constructor. Alternatively, apply a global timeout by setting the `REGEX_DEFAULT_MATCH_TIMEOUT` application domain property, using the `AppDomain.SetData` method.


## Example
The following example shows a HTTP request parameter that is matched against a regular expression which has exponential worst case performance. In the first case, it is matched without a timeout, which can lead to a denial of service. In the second case, a timeout is used to cancel the evaluation of the regular expression after 1 second.


```csharp
using System;
using System.Web;
using System.Text.RegularExpressions;

public class ReDoSHandler : IHttpHandler
{

    public void ProcessRequest(HttpContext ctx)
    {
        string userInput = ctx.Request.QueryString["userInput"];

        // BAD: User input is matched against a regex with exponential worst case behavior
        new Regex("^([a-z]*)*$").Match(userInput);

        // GOOD: Regex is given a timeout to avoid DoS
        new Regex("^([a-z]*)*$",
                  RegexOptions.IgnoreCase,
                  TimeSpan.FromSeconds(1)).Match(userInput);
    }
}

```

## References
* OWASP: [Regular expression Denial of Service - ReDoS](https://www.owasp.org/index.php/Regular_expression_Denial_of_Service_-_ReDoS).
* Wikipedia: [ReDoS](https://en.wikipedia.org/wiki/ReDoS).
* Wikipedia: [Time complexity](https://en.wikipedia.org/wiki/Time_complexity).
* Common Weakness Enumeration: [CWE-730](https://cwe.mitre.org/data/definitions/730.html).
* Common Weakness Enumeration: [CWE-400](https://cwe.mitre.org/data/definitions/400.html).