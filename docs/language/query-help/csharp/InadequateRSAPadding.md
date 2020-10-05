# Weak encryption: inadequate RSA padding

```
ID: cs/inadequate-rsa-padding
Kind: problem
Severity: warning
Precision: high
Tags: security external/cwe/cwe-327 external/cwe/cwe-780

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/csharp/ql/src/Security%20Features/InadequateRSAPadding.ql)

This query finds uses of RSA encryption without secure padding. Using PKCS#1 v1.5 padding can open up your application to several different attacks resulting in the exposure of the encryption key or the ability to determine plaintext from encrypted messages.


## Recommendation
Use the more secure PKCS#1 v2 (OAEP) padding.


## References
* Wikipedia. [RSA. Padding Schemes](http://en.wikipedia.org/wiki/RSA_(algorithm)#Padding_schemes).
* Common Weakness Enumeration: [CWE-327](https://cwe.mitre.org/data/definitions/327.html).
* Common Weakness Enumeration: [CWE-780](https://cwe.mitre.org/data/definitions/780.html).