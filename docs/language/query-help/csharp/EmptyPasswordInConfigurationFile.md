# Empty password in configuration file

```
ID: cs/empty-password-in-configuration
Kind: problem
Severity: warning
Precision: medium
Tags: security external/cwe/cwe-258 external/cwe/cwe-862

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/csharp/ql/src/Configuration/EmptyPasswordInConfigurationFile.ql)

The use of an empty string as a password in a configuration file is not secure.


## Recommendation
Choose a proper password and encrypt it if you need to store it in the configuration file.


## References
* Common Weakness Enumeration: [CWE-258](https://cwe.mitre.org/data/definitions/258.html).
* Common Weakness Enumeration: [CWE-862](https://cwe.mitre.org/data/definitions/862.html).