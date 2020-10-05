# 'requireSSL' attribute is not set to true

```
ID: cs/web/requiressl-not-set
Kind: problem
Severity: error
Precision: high
Tags: security external/cwe/cwe-319 external/cwe/cwe-614

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/csharp/ql/src/Security%20Features/CWE-614/RequireSSL.ql)

Sensitive data that is transmitted using HTTP is vulnerable to being read by a third party. By default, web forms and cookies are sent via HTTP, not HTTPS. This setting can be changed by setting the `requireSSL` attribute to `"true"` in `Web.config`.


## Recommendation
When using web forms, ensure that `Web.config` contains a `<forms>` element with the attribute `requireSSL="true"`.

When using cookies, ensure that SSL is used, either via the `<forms>` attribute above, or the `<httpCookies>` element, with the attribute `requireSSL="true"`. It is also possible to require cookies to use SSL programmatically, by setting the property `System.Web.HttpCookie.Secure` to `true`.


## Example
The following example shows where to specify `requireSSL="true"` in a `Web.config` file.


```none
<?xml version="1.0" encoding="utf-8" ?>
<configuration>
  <system.web>
    <authentication>
      <forms
        requireSSL="true"
        ... />
    </authentication>
    <httpCookies
        requireSSL="true"
        ... />
  </system.web>
</configuration>

```

## References
* MSDN: [HttpCookie.Secure Property](https://msdn.microsoft.com/en-us/library/system.web.httpcookie.secure(v=vs.110).aspx), [FormsAuthentication.RequireSSL Property](https://msdn.microsoft.com/en-us/library/system.web.security.formsauthentication.requiressl(v=vs.110).aspx), [forms Element for authentication](https://msdn.microsoft.com/en-us/library/1d3t3c61(v=vs.100).aspx), [httpCookies Element](https://msdn.microsoft.com/library/ms228262%28v=vs.100%29.aspx).
* Common Weakness Enumeration: [CWE-319](https://cwe.mitre.org/data/definitions/319.html).
* Common Weakness Enumeration: [CWE-614](https://cwe.mitre.org/data/definitions/614.html).