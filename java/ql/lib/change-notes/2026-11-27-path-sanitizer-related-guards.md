---
category: minorAnalysis
---
* Path injection sanitizers in `PathSanitizer.qll` that combine a prefix or blocklist check with a `..` traversal check now require both checks to apply to related values (connected by local taint flow), rather than allowing an unrelated check on another expression in the same method. This may result in additional true-positive alerts in `java/path-injection` and related queries.
