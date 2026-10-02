---
category: minorAnalysis
---
* The queries `java/ssrf` and `java/unvalidated-url-redirection` recognize case-insensitive comparisons of `URI.getHost()` with fixed string allowlist entries, as well as equality and case-insensitive comparisons when the host is stored in a local variable.
