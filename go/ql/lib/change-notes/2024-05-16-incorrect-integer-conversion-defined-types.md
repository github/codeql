---
category: minorAnalysis
---
* A bug has been fixed which meant that the query `go/incorrect-integer-conversion` did not consider type assertions and type switches which use a defined type whose underlying type is an integer type. This may lead to fewer false positive alerts.
