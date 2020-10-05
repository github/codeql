# ASP.NET config file enables directory browsing

```
ID: cs/web/directory-browse-enabled
Kind: problem
Severity: warning
Precision: very-high
Tags: security external/cwe/cwe-548

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/csharp/ql/src/Security%20Features/CWE-548/ASPNetDirectoryListing.ql)

ASP.NET applications that enable directory browsing can leak sensitive information to an attacker. The precise nature of the vulnerability depends on which files are listed and accessible.


## Recommendation
If this configuration may be used in production, remove the `directoryBrowse` element from the `Web.config` file or set the value to false.


## Example
The following example shows the `directoryBrowse` `enable` attribute set to true in a `Web.config` file for ASP.NET:


```none
<?xml version="1.0" encoding="utf-8" ?>
<configuration>
  <system.webServer>
    <directoryBrowse enable="true"/>
   ...
  </system.web>
</configuration>
```
To fix this problem, the `enable` attribute should be set to `false`, or the `directoryBrowse` element should be removed completely:


```none
<?xml version="1.0" encoding="utf-8" ?>
<configuration>
  <system.webServer>
    <directoryBrowse enable="false"/>
   ...
  </system.web>
</configuration>
```

## References
* MSDN: [directoryBrowse element](https://msdn.microsoft.com/en-us/library/ms691327(v=vs.90).aspx).
* Common Weakness Enumeration: [CWE-548](https://cwe.mitre.org/data/definitions/548.html).