# Log entries created from user input

```
ID: cs/log-forging
Kind: path-problem
Severity: error
Precision: high
Tags: security external/cwe/cwe-117

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/csharp/ql/src/Security%20Features/CWE-117/LogForging.ql)

If unsanitized user input is written to a log entry, a malicious user may be able to forge new log entries.

Forgery can occur if a user provides some input with characters that are interpreted when the log output is displayed. If the log is displayed as a plain text file, then new line characters can be used by a malicious user. If the log is displayed as HTML, then arbitrary HTML may be include to spoof log entries.


## Recommendation
User input should be suitably encoded before it is logged.

If the log entries are plain text then line breaks should be removed from user input, using `String.Replace` or similar. Care should also be taken that user input is clearly marked in log entries, and that a malicious user cannot cause confusion in other ways.

For log entries that will be displayed in HTML, user input should be HTML encoded using `HttpServerUtility.HtmlEncode` or similar before being logged, to prevent forgery and other forms of HTML injection.


## Example
In the following example, a user name, provided by the user, is logged using a logging framework. In the first case, it is logged without any sanitization. In the second case, `String.Replace` is used to ensure no line endings are present in the user input.


```csharp
using Microsoft.Extensions.Logging;
using System;
using System.IO;
using System.Web;

public class LogForgingHandler : IHttpHandler
{
    private ILogger logger;

    public void ProcessRequest(HttpContext ctx)
    {
        String username = ctx.Request.QueryString["username"];
        // BAD: User input logged as-is
        logger.Warn(username + " log in requested.");
        // GOOD: User input logged with new-lines removed
        logger.Warn(username.Replace(Environment.NewLine, "") + " log in requested");
    }
}

```

## References
* OWASP: [Log Injection](https://www.owasp.org/index.php/Log_Injection).
* Common Weakness Enumeration: [CWE-117](https://cwe.mitre.org/data/definitions/117.html).