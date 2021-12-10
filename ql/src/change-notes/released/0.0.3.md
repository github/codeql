## 0.0.3

### New Queries

* A new query "Log entries created from user input" (`go/log-injection`) has been added. The query reports user-provided data reaching calls to logging methods.

### Major Analysis Improvements

* The query "Incorrect conversion between integer types" has been improved to
  treat `math.MaxUint` and `math.MaxInt` as the values they would be on a
  32-bit architecture. This should lead to fewer false positive results.
