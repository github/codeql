# Cookie security: overly broad domain

```
ID: cs/web/broad-cookie-domain
Kind: problem
Severity: warning
Precision: high
Tags: security external/cwe/cwe-287

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/csharp/ql/src/Security%20Features/CookieWithOverlyBroadDomain.ql)

This rule finds cookies with an overly broad domain. Cookies with an overly broad domain, such as ".mybank.com", can be accessed by all web applications deployed on this domain and its sub-domains. A cookie with sensitive data, but with too broad a domain, could hence be read and tampered with by a less secure and untrusted application.


## Recommendation
Precisely define the domain of the web application for which this cookie is valid.


## Example
In this example `cookie1` is accessible from online-bank.com. `cookie2` is accessible from ebanking.online-bank.com and any subdomains of ebanking.online-bank.com.


```csharp
class CookieWithOverlyBroadDomain
{
    static public void AddCookie()
    {
        HttpCookie cookie1 = new HttpCookie("sessionID");
        cookie1.Domain = "online-bank.com";

        HttpCookie cookie2 = new HttpCookie("sessionID");
        cookie2.Domain = ".ebanking.online-bank.com";
    }
}

```
In the following example `cookie` is only accessible from ebanking.online-bank.com which is much more secure.


```csharp
class CookieWithOverlyBroadDomainFix
{
    static public void AddCookie()
    {
        HttpCookie cookie = new HttpCookie("sessionID");
        cookie.Domain = "ebanking.online-bank.com";
    }
}

```

## References
* MSDN: [HttpCookie.Domain Property](http://msdn.microsoft.com/en-us/library/system.web.httpcookie.domain.aspx).
* Common Weakness Enumeration: [CWE-287](https://cwe.mitre.org/data/definitions/287.html).