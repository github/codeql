# Header checking disabled

```
ID: cs/web/disabled-header-checking
Kind: problem
Severity: warning
Precision: high
Tags: security external/cwe/cwe-113

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/csharp/ql/src/Security%20Features/HeaderCheckingDisabled.ql)

This rule finds places in the code where header checking is disabled. When header checking is enabled, which is the default, the `\r` or `\n` characters found in a response header are encoded to `%0d` and `%0a`. This defeats header-injection attacks by making the injected material part of the same header line. If you disable header checking, you open potential attack vectors against your client code.


## Recommendation
Do not disable header checking.


## References
* MSDN. [HttpRuntimeSection.EnableHeaderChecking Property](http://msdn.microsoft.com/en-us/library/system.web.configuration.httpruntimesection.enableheaderchecking.aspx).
* Common Weakness Enumeration: [CWE-113](https://cwe.mitre.org/data/definitions/113.html).