# Cookie security: overly broad path

```
ID: cs/web/broad-cookie-path
Kind: problem
Severity: warning
Precision: high
Tags: security external/cwe/cwe-287

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/csharp/ql/src/Security%20Features/CookieWithOverlyBroadPath.ql)

This rule finds cookies with an overly broad path. Cookies with an overly broad path, such as the root context path ("/"), can be accessed by all web applications on the same domain name. A cookie with sensitive data, but with too broad a path, could hence be read and tampered by a less secure and untrusted application.


## Recommendation
Precisely define the path of the web application for which this cookie is valid.


## Example
In this example the cookie will be accessible to all applications regardless of their path. Most likely some of these applications are less secure than others and do not even need to access the same cookies.


```csharp
class CookieWithOverlyBroadPath
{
    static public void AddCookie()
    {
        HttpCookie cookie = new HttpCookie("sessionID");
        cookie.Path = "/";
    }
}

```
In the following example the cookie is only accessible to the web application at the "/ebanking" path.


```csharp
class CookieWithOverlyBroadPathFix
{
    static public void AddCookie()
    {
        HttpCookie cookie = new HttpCookie("sessionID");
        cookie.Path = "/ebanking";
    }
}

```

## References
* MSDN: [HttpCookie.Path Property](http://msdn.microsoft.com/en-us/library/system.web.httpcookie.path.aspx).
* Common Weakness Enumeration: [CWE-287](https://cwe.mitre.org/data/definitions/287.html).