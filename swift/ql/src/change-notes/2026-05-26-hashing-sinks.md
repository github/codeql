---
category: minorAnalysis
---
* Fixed an issue where common usage patterns for `CryptoKit` weren't being recognized as hashing sinks for the `swift/weak-sensitive-data-hashing` and `swift/weak-password-hashing` queries. These queries may find additional results after this change.
