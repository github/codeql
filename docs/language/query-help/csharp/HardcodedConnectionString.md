# Hard-coded connection string with credentials

```
ID: cs/hardcoded-connection-string-credentials
Kind: path-problem
Severity: error
Precision: high
Tags: security external/cwe/cwe-259 external/cwe/cwe-321 external/cwe/cwe-798

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/csharp/ql/src/Security%20Features/CWE-798/HardcodedConnectionString.ql)

Including unencrypted hard-coded inbound or outbound authentication credentials within source code or configuration files is dangerous because the credentials may be easily discovered.

Source or configuration files containing hard-coded credentials may be visible to an attacker. For example, the source code may be open source, or it may be leaked or accidentally revealed. For applications shipped as binaries, the credentials may be accessible within the compiled assemblies.

For inbound authentication, hard-coded credentials may allow unauthorized access to the system. This is particularly problematic if the credential is hard-coded in the source code, because it cannot be disabled easily. For outbound authentication, the hard-coded credentials may provide an attacker with privileged information or unauthorized access to some other system.


## Recommendation
Remove hard-coded credentials, such as user names, passwords and certificates, from source code, placing them in configuration files or other data stores if necessary. If possible, store configuration files including credential data separately from the source code, in a secure location with restricted access.

For outbound authentication details, consider encrypting the credentials or the enclosing data stores or configuration files, and using permissions to restrict access.

For inbound authentication details, consider hashing passwords using standard library functions where possible. For example, Microsoft provide the class `Microsoft.AspNet.Identity.PasswordHasher`.


## Example
The following examples shows different types of inbound and outbound authentication.

In the first case, we accept a password from a remote user, and compare it against a plaintext string literal. If an attacker acquires the source code, or the assemblies, they can observe the password, and can log in to the system. Furthermore, if such an intrusion was discovered, the application would need to be recompiled in order to change the password.

In the second case, the password is compared to a hashed and salted password stored in a configuration file, using the Microsoft provided `PasswordHasher.VerifyHashedPassword`. In this case, access to the source code or the assembly would not reveal the password to an attacker. Even access to the configuration file containing the password hash and salt would be of little value to an attacker, as it is usually extremely difficult to reverse engineer the password from the hash and salt.

In the final case, a password is changed to a new, hard-coded value. If an attacker has access to the source code, they will be able to observe the new password.


```csharp
using Microsoft.AspNet.Identity;
using System;
using System.Web;
using System.Web.Security;

public class HardCodedCredentialHandler : IHttpHandler
{

    public void ProcessRequest(HttpContext ctx)
    {
        string password = ctx.Request.QueryString["password"];

        // BAD: Inbound authentication made by comparison to string literal
        if (password == "myPa55word")
        {
            ctx.Response.Redirect("login");
        }

        string hashedPassword = loadPasswordFromSecretConfig();

        // GOOD: Inbound authentication made by comparing to a hash password from a config
        if (PasswordHasher.VerifyHashedPassword(hashedPassword, password))
        {
            ctx.Response.Redirect(VALID_REDIRECT);
        }

        // BAD: Set the password to a hardcoded string literal
        MembershipUser user = loadMembershipUser();
        user.ChangePassword(password, "myNewPa55word");
    }
}

```

## References
* OWASP: [XSS Use of hard-coded password](https://www.owasp.org/index.php/Use_of_hard-coded_password).
* Microsoft Docs: [Preventing Open Redirection Attacks (C#)](https://docs.microsoft.com/en-us/aspnet/mvc/overview/security/preventing-open-redirection-attacks).
* Common Weakness Enumeration: [CWE-259](https://cwe.mitre.org/data/definitions/259.html).
* Common Weakness Enumeration: [CWE-321](https://cwe.mitre.org/data/definitions/321.html).
* Common Weakness Enumeration: [CWE-798](https://cwe.mitre.org/data/definitions/798.html).