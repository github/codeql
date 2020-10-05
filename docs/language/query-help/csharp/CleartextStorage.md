# Clear text storage of sensitive information

```
ID: cs/cleartext-storage-of-sensitive-information
Kind: path-problem
Severity: error
Precision: high
Tags: security external/cwe/cwe-312 external/cwe/cwe-315 external/cwe/cwe-359

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/csharp/ql/src/Security%20Features/CWE-312/CleartextStorage.ql)

Sensitive information that is stored unencrypted is accessible to an attacker who gains access to the storage. This is particularly important for cookies, which are stored on the machine of the end-user.


## Recommendation
Ensure that sensitive information is always encrypted before being stored. For ASP.NET applications, the `System.Web.Security.MachineKey` class may be used to encode sensitive information.

If possible, avoid placing sensitive information in cookies all together. Instead, prefer storing a key in the cookie that can be used to lookup the sensitive information.

In general, decrypt sensitive information only at the point where it is necessary for it to be used in cleartext.


## Example
The following example shows two ways of storing user credentials in a cookie. In the 'BAD' case, the credentials are simply stored in cleartext. In the 'GOOD' case, the credentials are protected before storing them, using `MachineKey.Protect`, wrapped in a utility method.


```csharp
using System.Text;
using System.Web;
using System.Web.Security;

public class CleartextStorageHandler : IHttpHandler
{

    public void ProcessRequest(HttpContext ctx)
    {
        string accountName = ctx.Request.QueryString["AccountName"];
        // BAD: Setting a cookie value with cleartext sensitive data.
        ctx.Response.Cookies["AccountName"].Value = accountName;
        // GOOD: Encoding the value before setting it.
        ctx.Response.Cookies["AccountName"].Value = Protect(accountName, "Account name");
    }

    /// <summary>
    /// Protect the cleartext value, using the given type.
    /// </summary>
    /// <value>
    /// The protected value, which is no longer cleartext.
    /// </value>
    public string Protect(string value, string type)
    {
        return Encoding.UTF8.GetString(MachineKey.Protect(Encoding.UTF8.GetBytes(value), type));
    }
}

```

## References
* M. Dowd, J. McDonald and J. Schuhm, *The Art of Software Security Assessment*, 1st Edition, Chapter 2 - 'Common Vulnerabilities of Encryption', p. 43. Addison Wesley, 2006.
* M. Howard and D. LeBlanc, *Writing Secure Code*, 2nd Edition, Chapter 9 - 'Protecting Secret Data', p. 299. Microsoft, 2002.
* Common Weakness Enumeration: [CWE-312](https://cwe.mitre.org/data/definitions/312.html).
* Common Weakness Enumeration: [CWE-315](https://cwe.mitre.org/data/definitions/315.html).
* Common Weakness Enumeration: [CWE-359](https://cwe.mitre.org/data/definitions/359.html).