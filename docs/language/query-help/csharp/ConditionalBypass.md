# User-controlled bypass of sensitive method

```
ID: cs/user-controlled-bypass
Kind: path-problem
Severity: error
Precision: high
Tags: security external/cwe/cwe-807 external/cwe/cwe-247 external/cwe/cwe-350

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/csharp/ql/src/Security%20Features/CWE-807/ConditionalBypass.ql)

Many C# constructs enable code statements to be executed conditionally, for example, `if` statements and `for` statements. If the statements contain important authentication or login code, and user-controlled data determines whether or not the code is executed, an attacker may be able to bypass security systems.


## Recommendation
Never decide whether to authenticate a user based on data that may be controlled by that user. If necessary, ensure that the data is validated extensively when it is input before any authentication checks are performed.

It is still possible to have a system that "remembers" users, thus not requiring the user to login on every interaction. For example, personalization settings can be applied without authentication because this is not sensitive information. However, users should be allowed to take sensitive actions only when they have been fully authenticated.


## Example
This example shows two ways of deciding whether to authenticate a user. The first way shows a decision that is based on the value of a cookie. Cookies can be easily controlled by the user, and so this allows a user to become authenticated without providing valid credentials. The second, more secure way shows a decision that is based on looking up the user in a security database.


```csharp
public boolean doLogin(HttpCookie adminCookie, String user, String password)
{

    // BAD: login is executed only if the value of 'adminCookie' is 'false',
    // but 'adminCookie' is controlled by the user
    if (adminCookie.Value == "false")
        return login(user, password);

    return true;
}

public boolean doLogin(HttpCookie adminCookie, String user, String password)
{
    // GOOD: use server-side information based on the credentials to decide
    // whether user has privileges
    bool isAdmin = queryDbForAdminStatus(user, password);
    if (!isAdmin)
        return login(user, password);

    return true;
}

```

## References
* Common Weakness Enumeration: [CWE-807](https://cwe.mitre.org/data/definitions/807.html).
* Common Weakness Enumeration: [CWE-247](https://cwe.mitre.org/data/definitions/247.html).
* Common Weakness Enumeration: [CWE-350](https://cwe.mitre.org/data/definitions/350.html).