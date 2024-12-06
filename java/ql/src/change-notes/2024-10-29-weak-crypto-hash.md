---
category: minorAnalysis
---
* The `java/weak-cryptographic-algorithm` query has been updated to no longer report uses of hash functions such as `MD5` and `SHA1` even if they are known to be weak. These hash algorithms are used very often in non-sensitive contexts, making the query too imprecise in practice. The `java/potentially-weak-cryptographic-algorithm` query has been updated to report these uses instead.
