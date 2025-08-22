## 1.2.5

### Minor Analysis Improvements

* The `cpp/unclear-array-index-validation` ("Unclear validation of array index") query has been improved to reduce false positives and increase true positives.
* Fixed false positives in the `cpp/uninitialized-local` ("Potentially uninitialized local variable") query if there are extraction errors in the function.
* The `cpp/incorrect-string-type-conversion` query now produces fewer false positives caused by failure to detect byte arrays.
* The `cpp/incorrect-string-type-conversion` query now produces fewer false positives caused by failure to recognize dynamic checks prior to possible dangerous widening.
