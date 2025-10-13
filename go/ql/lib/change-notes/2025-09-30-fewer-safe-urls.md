---
category: minorAnalysis
---
* `go/unvalidated-url-redirection` and `go/request-forgery` have a shared notion of a safe URL, which is known to not be malicious. Some URLs which were incorrectly considered safe are now correctly considered unsafe. This may lead to more alerts for those two queries.
