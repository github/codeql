## 2.2.0

### Major Analysis Improvements

* The `js/incomplete-sanitization` query now also checks regular expressions constructed using `new RegExp(..)`. Previously it only checked regular expression literals.
* Regular expression-based sanitisers implemented with `new RegExp(..)` are now detected in more cases.
* Regular expression related queries now account for unknown flags.

### Minor Analysis Improvements

* Added taint-steps for `String.prototype.toWellFormed`.
* Added taint-steps for `Map.groupBy` and `Object.groupBy`.
* Added taint-steps for `Array.prototype.findLast`.
* Added taint-steps for `Array.prototype.findLastIndex`.
