# Encryption using ECB

```
ID: cs/ecb-encryption
Kind: problem
Severity: warning
Precision: high
Tags: security external/cwe/cwe-327

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/csharp/ql/src/Security%20Features/Encryption%20using%20ECB.ql)

ECB should not be used as a mode for encryption. It has dangerous weaknesses. Data is encrypted the same way every time meaning the same plaintext input will always produce the same cyphertext. This makes encrypted messages vulnerable to replay attacks.


## Recommendation
Use a different CypherMode.


## References
* Wikipedia, Block cypher modes of operation, [Electronic codebook (ECB)](https://en.wikipedia.org/wiki/Block_cipher_mode_of_operation#Electronic_codebook_.28ECB.29).
* Common Weakness Enumeration: [CWE-327](https://cwe.mitre.org/data/definitions/327.html).