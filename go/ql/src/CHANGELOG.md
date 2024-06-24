## 1.0.2

No user-facing changes.

## 1.0.1

No user-facing changes.

## 1.0.0

### Breaking Changes

* CodeQL package management is now generally available, and all GitHub-produced CodeQL packages have had their version numbers increased to 1.0.0.

### Minor Analysis Improvements

* The query `go/incorrect-integer-conversion` has now been restricted to only use flow through value-preserving steps. This reduces false positives, especially around type switches.

## 0.7.16

No user-facing changes.

## 0.7.15

### Minor Analysis Improvements

* The query `go/incomplete-hostname-regexp` now recognizes more sources involving concatenation of string literals and also follows flow through string concatenation. This may lead to more alerts.
* Added some more barriers to flow for `go/incorrect-integer-conversion` to reduce false positives, especially around type switches.

## 0.7.14

No user-facing changes.

## 0.7.13

### New Queries

* The query "Slice memory allocation with excessive size value" (`go/uncontrolled-allocation-size`) has been promoted from experimental to the main query pack. Its results will now appear by default. This query was originally [submitted as an experimental query by @Malayke](https://github.com/github/codeql/pull/15130).

### Minor Analysis Improvements

* The query `go/hardcoded-credentials` no longer discards string literals based on "weak password" heuristics.
* The query `go/sql-injection` now recognizes more sinks in the package `github.com/Masterminds/squirrel`.

## 0.7.12

No user-facing changes.

## 0.7.11

No user-facing changes.

## 0.7.10

No user-facing changes.

## 0.7.9

### New Queries

* The query "Missing JWT signature check" (`go/missing-jwt-signature-check`) has been promoted from experimental to the main query pack. Its results will now appear by default. This query was originally [submitted as an experimental query by @am0o0](https://github.com/github/codeql/pull/14075).

### Major Analysis Improvements

* The query "Use of a hardcoded key for signing JWT" (`go/hardcoded-key`) has been promoted from experimental to the main query pack. Its results will now appear by default as part of `go/hardcoded-credentials`. This query was originally [submitted as an experimental query by @porcupineyhairs](https://github.com/github/codeql/pull/9378).

## 0.7.8

No user-facing changes.

## 0.7.7

### Minor Analysis Improvements

* The query `go/insecure-randomness` now recognizes the selection of candidates from a predefined set using a weak RNG when the result is used in a sensitive operation. Also, false positives have been reduced by adding more sink exclusions for functions in the `crypto` package not related to cryptographic operations.
* Added more sources and sinks to the query `go/clear-text-logging`.

## 0.7.6

### Minor Analysis Improvements

* There was a bug in the query `go/incorrect-integer-conversion` which meant that upper bound checks using a strict inequality (`<`) and comparing against `math.MaxInt` or `math.MaxUint` were not considered correctly, which led to false positives. This has now been fixed.

## 0.7.5

No user-facing changes.

## 0.7.4

No user-facing changes.

## 0.7.3

No user-facing changes.

## 0.7.2

### Minor Analysis Improvements

* The query `go/incorrect-integer-conversion` now correctly recognizes more guards of the form `if val <= x` to protect a conversion `uintX(val)`.

## 0.7.1

### Minor Analysis Improvements

* The query "Incorrect conversion between integer types" (`go/incorrect-integer-conversion`) has been improved. It can now detect parsing an unsigned integer type (like `uint32`) and converting it to the signed integer type of the same size (like `int32`), which may lead to more results. It also treats `int` and `uint` more carefully, which may lead to more results or fewer incorrect results.

## 0.7.0

No user-facing changes.

## 0.6.5

No user-facing changes.

## 0.6.4

No user-facing changes.

## 0.6.3

No user-facing changes.

## 0.6.2

No user-facing changes.

## 0.6.1

No user-facing changes.

## 0.6.0

### Bug Fixes

* The query "Arbitrary file write during zip extraction ("zip slip")" (`go/zipslip`) has been renamed to "Arbitrary file access during archive extraction ("Zip Slip")."

## 0.5.4

No user-facing changes.

## 0.5.3

No user-facing changes.

## 0.5.2

No user-facing changes.

## 0.5.1

No user-facing changes.

## 0.5.0

### Minor Analysis Improvements

* The receiver arguments of `net/http.Header.Set` and `.Del` are no longer flagged by query `go/untrusted-data-to-external-api`.

## 0.4.6

No user-facing changes.

## 0.4.5

No user-facing changes.

## 0.4.4

### Minor Analysis Improvements

* The query `go/incorrect-integer-conversion` now correctly recognizes guards of the form `if val <= x` to protect a conversion `uintX(val)` when `x` is in the range `(math.MaxIntX, math.MaxUintX]`.

## 0.4.3

### New Queries

* Added a new query, `go/unhandled-writable-file-close`, to detect instances where writable file handles are closed without appropriate checks for errors.

### Query Metadata Changes

* The precision of the `go/log-injection` query was decreased from `high` to `medium`, since it may not be able to identify every way in which log data may be sanitized. This also aligns it with the precision of comparable queries for other languages.

## 0.4.2

No user-facing changes.

## 0.4.1

### Minor Analysis Improvements

* Replacing "\r" or "\n" using the functions `strings.ReplaceAll`, `strings.Replace`, `strings.Replacer.Replace` and `strings.Replacer.WriteString` has been added as a sanitizer for the queries "Log entries created from user input".
* The functions `strings.Replacer.Replace` and `strings.Replacer.WriteString` have been added as sanitizers for the query "Potentially unsafe quoting".

## 0.4.0

### Minor Analysis Improvements

* The `AlertSuppression.ql` query has been updated to support the new `// codeql[query-id]` supression comments. These comments can be used to suppress an alert and must be placed on a blank line before the alert. In addition the legacy `// lgtm` and `// lgtm[query-id]` comments can now also be placed on the line before an alert.

## 0.3.6

No user-facing changes.

## 0.3.5

No user-facing changes.

## 0.3.4

No user-facing changes.

## 0.3.3

### Minor Analysis Improvements

* Query `go/clear-text-logging` now excludes `GetX` methods of protobuf `Message` structs, except where taint is specifically known to belong to the right field. This is to avoid FPs where taint is written to one field and then spuriously read from another.

## 0.3.2

### Minor Analysis Improvements

* The alert messages of many queries were changed to better follow the style guide and make the messages consistent with other languages.

## 0.3.1

No user-facing changes.

## 0.3.0

### Query Metadata Changes

* Added the `security-severity` tag and CWE tag to the `go/insecure-hostkeycallback` query.

### Minor Analysis Improvements

* The alert message of many queries have been changed to make the message consistent with other languages.

## 0.2.5

## 0.2.4

## 0.2.3

### Minor Analysis Improvements

* The query `go/path-injection` no longer considers user-controlled numeric or boolean-typed data as potentially dangerous.

## 0.2.2

## 0.2.1

## 0.2.0

## 0.1.4

## 0.1.3

## 0.1.2

## 0.1.1

## 0.1.0

## 0.0.12

## 0.0.11

## 0.0.10

## 0.0.9

### New Queries

* Added a new query, `go/unexpected-nil-value`, to find calls to `Wrap` from `pkg/errors` where the error argument is always nil.

## 0.0.8

## 0.0.7

## 0.0.6

## 0.0.5

### Minor Analysis Improvements

* Fixed sanitization by calls to `strings.Replace` and `strings.ReplaceAll` in queries `go/log-injection` and `go/unsafe-quoting`.

## 0.0.4

### New Queries

* A new query _Log entries created from user input_ (`go/log-injection`) has been added. The query reports user-provided data reaching calls to logging methods.

## 0.0.3

### New Queries

* A new query "Log entries created from user input" (`go/log-injection`) has been added. The query reports user-provided data reaching calls to logging methods.

### Major Analysis Improvements

* The query "Incorrect conversion between integer types" has been improved to
  treat `math.MaxUint` and `math.MaxInt` as the values they would be on a
  32-bit architecture. This should lead to fewer false positive results.
