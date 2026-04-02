---
category: minorAnalysis
---
* The `java/potentially-weak-cryptographic-algorithm` query no longer flags Elliptic Curve algorithms (`EC`, `ECDSA`, `ECDH`, `EdDSA`, `Ed25519`, `Ed448`, `XDH`, `X25519`, `X448`), HMAC-based algorithms (`HMACSHA1`, `HMACSHA256`, `HMACSHA384`, `HMACSHA512`), or PBKDF2 key derivation as potentially insecure. These are modern, secure algorithms recommended by NIST and other standards bodies. This will reduce the number of false positives for this query.
* The first argument of the method `getInstance` of `java.security.Signature` is now modeled as a sink for `java/potentially-weak-cryptographic-algorithm`, `java/weak-cryptographic-algorithm` and `java/rsa-without-oaep`. This will increase the number of alerts for these queries.
