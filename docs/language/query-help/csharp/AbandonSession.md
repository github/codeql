# Failure to abandon session

```
ID: cs/session-reuse
Kind: problem
Severity: error
Precision: high
Tags: security external/cwe/cwe-384

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/csharp/ql/src/Security%20Features/CWE-384/AbandonSession.ql)

Reusing a session could allow an attacker to gain unauthorized access to another account. Always ensure that, when a user logs in or out, the current session is abandoned so that a new session may be started.


## Recommendation
Always call `HttpSessionState.Abandon()` to ensure that the previous session is not used by the new user.


## Example
The following example shows the previous session being used after authentication. This would allow a previous user to use the new user's account.


```csharp
public void Login(HttpContext ctx, string username, string password)
{
    if (FormsAuthentication.Authenticate(username, password)
    {
        // BAD: Reusing the previous session
        ctx.Session["Mode"] = GetModeForUser(username);
    }
}

```
This code example solves the problem by not reusing the session, and instead calling `Abandon()` to ensure that the session is not reused.


```csharp
public void Login(HttpContext ctx, string username, string password)
{
    if (FormsAuthentication.Authenticate(username, password)
    {
        // GOOD: Abandon the session first.
        ctx.Session.Abandon();
    }
}

```

## References
* MSDN: [ASP.NET Session State Overview](https://msdn.microsoft.com/en-us/library/ms178581.aspx), [HttpSessionState.Abandon Method ()](https://msdn.microsoft.com/en-us/library/system.web.sessionstate.httpsessionstate.abandon(v=vs.110).aspx).
* Common Weakness Enumeration: [CWE-384](https://cwe.mitre.org/data/definitions/384.html).