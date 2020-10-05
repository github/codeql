# Password in configuration file

```
ID: js/password-in-configuration-file
Kind: problem
Severity: warning
Precision: medium
Tags: security external/cwe/cwe-256 external/cwe/cwe-260 external/cwe/cwe-313

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/javascript/ql/src/Security/CWE-313/PasswordInConfigurationFile.ql)

Storing a plaintext password in a configuration file allows anyone who can read the file to access the password-protected resources. Therefore it is a common attack vector.


## Recommendation
Passwords stored in configuration files should always be encrypted.


## References
* Common Weakness Enumeration: [CWE-256](https://cwe.mitre.org/data/definitions/256.html).
* Common Weakness Enumeration: [CWE-260](https://cwe.mitre.org/data/definitions/260.html).
* Common Weakness Enumeration: [CWE-313](https://cwe.mitre.org/data/definitions/313.html).