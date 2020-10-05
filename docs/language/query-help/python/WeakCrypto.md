# Use of weak cryptographic key

```
ID: py/weak-crypto-key
Kind: problem
Severity: error
Precision: high
Tags: security external/cwe/cwe-326

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/python/ql/src/Security/CWE-326/WeakCrypto.ql)

Modern encryption relies on it being computationally infeasible to break the cipher and decode a message without the key. As computational power increases, the ability to break ciphers grows and keys need to become larger.

The three main asymmetric key algorithms currently in use are Rivest–Shamir–Adleman (RSA) cryptography, Digital Signature Algorithm (DSA), and Elliptic-curve cryptography (ECC). With current technology, key sizes of 2048 bits for RSA and DSA, or 224 bits for ECC, are regarded as unbreakable.


## Recommendation
Increase the key size to the recommended amount or larger. For RSA or DSA this is at least 2048 bits, for ECC this is at least 224 bits.


## References
* Wikipedia: [Digital Signature Algorithm](https://en.wikipedia.org/wiki/Digital_Signature_Algorithm).
* Wikipedia: [RSA cryptosystem](https://en.wikipedia.org/wiki/RSA_(cryptosystem)).
* Wikipedia: [Elliptic-curve cryptography](https://en.wikipedia.org/wiki/Elliptic-curve_cryptography).
* Python cryptography module: [cryptography.io](https://cryptography.io/en/latest/).
* NIST: [ Recommendation for Transitioning the Use of Cryptographic Algorithms and Key Lengths](https://nvlpubs.nist.gov/nistpubs/SpecialPublications/NIST.SP.800-131Ar1.pdf).
* Common Weakness Enumeration: [CWE-326](https://cwe.mitre.org/data/definitions/326.html).