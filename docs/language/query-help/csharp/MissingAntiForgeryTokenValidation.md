# Missing cross-site request forgery token validation

```
ID: cs/web/missing-token-validation
Kind: problem
Severity: error
Precision: high
Tags: security external/cwe/cwe-352

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/csharp/ql/src/Security%20Features/CWE-352/MissingAntiForgeryTokenValidation.ql)

Web applications that use tokens to prevent cross-site request forgery (CSRF) should validate the tokens for all Http POST requests.

Although login and authentication methods are not vulnerable to traditional CSRF attacks, they still need to be protected with a token or other mitigation. This because an unprotected login page can be used by an attacker to force a login using an account controlled by the attacker. Subsequent requests to the site are then made using this account, without the user being aware that this is the case. This can result in the user associating private information with the attacker-controlled account.


## Recommendation
The appropriate attribute should be added to this method to ensure the anti-forgery token is validated when this action method is called. If using the MVC-provided anti-forgery framework this will be the `[ValidateAntiForgeryToken]` attribute.

Alternatively, you may consider including a global filter that applies token validation to all POST requests.


## Example
In the following example an ASP.NET MVC `Controller` is using the `[ValidateAntiForgeryToken]` attribute to mitigate against CSRF attacks. It has been applied correctly to the `UpdateDetails` method. However, this attribute has not been applied to the `Login` method. This should be fixed by adding this attribute.


```csharp
using System.Web.Mvc;

public class HomeController : Controller
{
    // BAD: Anti forgery token has been forgotten
    [HttpPost]
    public ActionResult Login()
    {
        return View();
    }

    // GOOD: Anti forgery token is validated
    [HttpPost]
    [ValidateAntiForgeryToken]
    public ActionResult UpdateDetails()
    {
        return View();
    }
}

```

## References
* Wikipedia: [Cross-Site Request Forgery](https://en.wikipedia.org/wiki/Cross-site_request_forgery).
* Microsoft Docs: [XSRF/CSRF Prevention in ASP.NET MVC and Web Pages](https://docs.microsoft.com/en-us/aspnet/mvc/overview/security/xsrfcsrf-prevention-in-aspnet-mvc-and-web-pages).
* Common Weakness Enumeration: [CWE-352](https://cwe.mitre.org/data/definitions/352.html).