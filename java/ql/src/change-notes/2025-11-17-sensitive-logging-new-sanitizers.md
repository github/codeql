---
category: minorAnalysis
---
* Calls to `substring` (for Java), `take` (for Kotlin) and similar functions, when called with a fixed length less than or equal to 7, are now treated as sanitizers for the `java/sensitive-log` query.