---
category: minorAnalysis
---
* The `rb/weak-cryptographic-algorithm` has been updated to no longer report uses of hash functions such as `MD5` and `SHA1` even if they are known to be weak. These hash algorithms are used very often in non-sensitive contexts, making the query too imprecise in practice.
