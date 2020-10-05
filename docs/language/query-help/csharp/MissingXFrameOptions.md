# Missing X-Frame-Options HTTP header

```
ID: cs/web/missing-x-frame-options
Kind: problem
Severity: error
Precision: high
Tags: security external/cwe/cwe-451 external/cwe/cwe-829

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/csharp/ql/src/Security%20Features/CWE-451/MissingXFrameOptions.ql)

Web sites that do not specify the `X-Frame-Options` HTTP header may be vulnerable to UI redress attacks ("clickjacking"). In these attacks, the vulnerable site is loaded in a frame on an attacker-controlled site which uses opaque or transparent layers to trick the user into unintentionally clicking a button or link on the vulnerable site.


## Recommendation
Set the `X-Frame-Options` HTTP header to `DENY`, to instruct web browsers to block attempts to load the site in a frame. Alternatively, if framing is needed in certain circumstances, specify `SAMEORIGIN` or `ALLOW FROM: ...` to limit the ability to frame the site to pages from the same origin, or from an allowed whitelist of trusted domains.

For ASP.NET web applications, the header may be specified either in the `Web.config` file, using the `<customHeaders>` tag, or within the source code of the application using the `HttpResponse.AddHeader` method. In general, prefer specifying the header in the `Web.config` file to ensure it is added to all requests. If adding it to the source code, ensure that it is added unconditionally to all requests. For example, add the header in the `Application_BeginRequest` method in the `global.asax` file.


## Example
The following example shows how to specify the `X-Frame-Options` header within the `Web.config` file for ASP.NET:


```none
<?xml version="1.0" encoding="utf-8" ?>
<configuration>
  <system.web>
  </system.web>
  <system.webServer>
    <httpProtocol>
      <customHeaders>
        <add name="X-Frame-Options" value="SAMEORIGIN" />
      </customHeaders>
    </httpProtocol>
  </system.webServer>
</configuration>

```
This next example shows how to specify the `X-Frame-Options` header within the `global.asax` file for ASP.NET application:


```csharp
protected void Application_BeginRequest(object sender, EventArgs e)
{
    HttpContext.Current.Response.AddHeader("X-Frame-Options", "DENY");
}

```

## References
* OWASP: [Clickjacking Defense Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Clickjacking_Defense_Cheat_Sheet.html).
* Mozilla: [X-Frame-Options](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/X-Frame-Options)
* Common Weakness Enumeration: [CWE-451](https://cwe.mitre.org/data/definitions/451.html).
* Common Weakness Enumeration: [CWE-829](https://cwe.mitre.org/data/definitions/829.html).