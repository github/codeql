# Value shadowing: server variable

```
ID: cs/web/ambiguous-server-variable
Kind: problem
Severity: warning
Precision: medium
Tags: security maintainability frameworks/asp.net

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/csharp/ql/src/Input%20Validation/ValueShadowingServerVariable.ql)

Relying on `HttpRequest` to provide access to a particular server variable is not safe as it can be overridden by the client. The `HttpRequest` class implements an indexer to provide a simplified, combined access to its `QueryString`, `Form` , `Cookies`, or ` ServerVariables` collections, in that particular order. When searching for a variable, the first match is returned: `QueryString` parameters hence supersede values from forms, cookies and server variables, and so on. This is a serious attack vector since an attacker could inject a value in the query string that you do not expect, and which supersedes the value of the server variable you were actually trying to check.


## Recommendation
Explicitly restrict the search to the `ServerVariables` collection.


## Example
In this example the server attempts to ensure the user is using an HTTPS connection. Because the programmer used the `HttpRequest` indexer, URLs like ` http://www.example.org/?HTTPS=ON` appear to be from a secure connection even though they are not.


```csharp
class ValueShadowingServerVariable
{
    public bool isHTTPS(HttpRequest request)
    {
        String https = request["HTTPS"];
        return https == "ON";
    }
}

```
This can be easily fixed by explicitly specifying that we are looking for a server variable.


```csharp
class ValueShadowingServerVariableFix
{
    public bool isHTTPS(HttpRequest request)
    {
        String https = request.ServerVariables["HTTPS"];
        return https == "ON";
    }
}

```

## References
* MSDN: [HttpRequest.Item](http://msdn.microsoft.com/en-us/library/system.web.httprequest.item(v=VS.100).aspx).
* MSDN: [IIS Server Variables](http://msdn.microsoft.com/en-us/library/ms524602.aspx).