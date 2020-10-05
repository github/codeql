# Weak encryption: Insufficient key size

```
ID: cs/insufficient-key-size
Kind: problem
Severity: warning
Precision: high
Tags: security external/cwe/cwe-327

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/csharp/ql/src/Security%20Features/InsufficientKeySize.ql)

This rule finds uses of encryption algorithms with too small a key size. Encryption algorithms are vulnerable to brute force attack when too small a key size is used.


## Recommendation
The key should be at least 1024-bit long when using RSA encryption, and 128-bit long when using symmetric encryption.


## References
* Wikipedia. [Key size](http://en.wikipedia.org/wiki/Key_size).
* Common Weakness Enumeration: [CWE-327](https://cwe.mitre.org/data/definitions/327.html).