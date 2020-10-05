# Value shadowing

```
ID: cs/web/ambiguous-client-variable
Kind: problem
Severity: warning
Precision: medium
Tags: security maintainability frameworks/asp.net

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/csharp/ql/src/Input%20Validation/ValueShadowing.ql)

Relying on `HttpRequest` to provide access to a particular client variable is not safe. The `HttpRequest` class implements an indexer to provide a simplified, combined access to its `QueryString`, `Form`, `Cookies`, or ` ServerVariables` collections, in that particular order. When searching for a variable, the first match is returned: `QueryString` parameters hence supersede values from forms, cookies and server variables, and so on. This is a serious attack vector since an attacker could inject a value in the query string that you do not expect, and which supersedes the value of a more trusted collection.


## Recommendation
Explicitly restrict the search to one of the `QueryString`, `Form` or `Cookies` collections.


## Example
In this example an attempt has been made to prevent cross site request forgery attacks by comparing a cookie set by the server with a form variable sent by the user. The problem is that if the user did not send a form variable called `csrf` then the collection will fall back to using the cookie value, making it look like a forged request was initiated by the user.


```csharp
class ValueShadowing
{
    public bool checkCSRF(HttpRequest request)
    {
        string postCSRF = request["csrf"];
        string cookieCSRF = request.Cookies["csrf"];
        return postCSRF.Equals(cookieCSRF);
    }
}

```
This can be easily fixed by explicitly specifying that we are looking for a form variable.


```csharp
class ValueShadowingFix
{
    public bool checkCSRF(HttpRequest request)
    {
        string postCSRF = request.Form["csrf"];
        string cookieCSRF = request.Cookies["csrf"];
        return postCSRF.Equals(cookieCSRF);
    }
}

```

## References
* MSDN: [HttpRequest.Item](http://msdn.microsoft.com/en-us/library/system.web.httprequest.item(v=VS.100).aspx).