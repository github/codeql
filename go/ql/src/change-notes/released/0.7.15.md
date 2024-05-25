## 0.7.15

### Minor Analysis Improvements

* The query `go/incomplete-hostname-regexp` now recognizes more sources involving concatenation of string literals and also follows flow through string concatenation. This may lead to more alerts.
* Added some more barriers to flow for `go/incorrect-integer-conversion` to reduce false positives, especially around type switches.
