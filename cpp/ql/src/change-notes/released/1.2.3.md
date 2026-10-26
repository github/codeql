## 1.2.3

### Minor Analysis Improvements

* Removed false positives caused by buffer accesses in unreachable code
* Removed false positives caused by inconsistent type checking
* Add modeling of C functions that don't throw, thereby increasing the precision of the `cpp/incorrect-allocation-error-handling` ("Incorrect allocation-error handling") query. The query now produces additional true positives.
