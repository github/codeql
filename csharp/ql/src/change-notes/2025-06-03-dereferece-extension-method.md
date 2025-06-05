---
category: minorAnalysis
---
* The queries `cs/dereferenced-value-is-always-null` and `cs/dereferenced-value-may-be-null` have been improved to reduce false positives. The queries no longer assume that expressions are dereferenced when passed as the receiver (`this` parameter) to extension methods where that parameter is a nullable type.
