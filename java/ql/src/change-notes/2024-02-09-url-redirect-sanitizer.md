---
category: minorAnalysis
---
* The query `java/unvalidated-url-redirection` now sanitizes results following the same logic as the query `java/ssrf`. URLs the destination of which cannot be externally controlled will not be reported anymore.
