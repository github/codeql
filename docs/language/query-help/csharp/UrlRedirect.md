# URL redirection from remote source

```
ID: cs/web/unvalidated-url-redirection
Kind: path-problem
Severity: error
Precision: high
Tags: security external/cwe/cwe-601

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/csharp/ql/src/Security%20Features/CWE-601/UrlRedirect.ql)

Directly incorporating user input into a URL redirect request without validating the input can facilitate phishing attacks. In these attacks, unsuspecting users can be redirected to a malicious site that looks very similar to the real site they intend to visit, but which is controlled by the attacker.


## Recommendation
To guard against untrusted URL redirection, it is advisable to avoid putting user input directly into a redirect URL. Instead, maintain a list of authorized redirects on the server; then choose from that list based on the user input provided.


## Example
The following example shows an HTTP request parameter being used directly in a URL redirect without validating the input, which facilitates phishing attacks. It also shows how to remedy the problem by validating the user input against a known fixed string.


```csharp
using System;
using System.Web;

public class UnvalidatedUrlHandler : IHttpHandler
{
    private const String VALID_REDIRECT = "http://cwe.mitre.org/data/definitions/601.html";

    public void ProcessRequest(HttpContext ctx)
    {
        // BAD: a request parameter is incorporated without validation into a URL redirect
        ctx.Response.Redirect(ctx.Request.QueryString["page"]);

        // GOOD: the request parameter is validated against a known fixed string
        if (VALID_REDIRECT == ctx.Request.QueryString["page"])
        {
            ctx.Response.Redirect(VALID_REDIRECT);
        }
    }
}

```

## References
* OWASP: [XSS Unvalidated Redirects and Forwards Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Unvalidated_Redirects_and_Forwards_Cheat_Sheet.html).
* Microsoft Docs: [Preventing Open Redirection Attacks (C#)](https://docs.microsoft.com/en-us/aspnet/mvc/overview/security/preventing-open-redirection-attacks).
* Common Weakness Enumeration: [CWE-601](https://cwe.mitre.org/data/definitions/601.html).