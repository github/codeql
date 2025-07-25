## 1.4.1

### Minor Analysis Improvements

* `filepath.IsLocal` is now recognized as a sanitizer against path-traversal and related vulnerabilities.

## 1.4.0

### Query Metadata Changes

* The tag `quality` has been added to multiple Go quality queries for consistency. They have all been given a tag for one of the two top-level categories `reliability` or `maintainability`, and a tag for a sub-category. See [Query file metadata and alert message style guide](https://github.com/github/codeql/blob/main/docs/query-metadata-style-guide.md#quality-query-sub-category-tags) for more information about these categories.
* The tag `external/cwe/cwe-129` has been added to `go/constant-length-comparison`.
* The tag `external/cwe/cwe-193` has been added to `go/index-out-of-bounds`.
* The tag `external/cwe/cwe-197` has been added to `go/shift-out-of-range`.
* The tag `external/cwe/cwe-248` has been added to `go/redundant-recover`.
* The tag `external/cwe/cwe-252` has been added to `go/missing-error-check` and `go/unhandled-writable-file-close`.
* The tag `external/cwe/cwe-480` has been added to `go/mistyped-exponentiation`.
* The tag `external/cwe/cwe-570` has been added to `go/impossible-interface-nil-check` and `go/comparison-of-identical-expressions`.
* The tag `external/cwe/cwe-571` has been added to `go/negative-length-check` and `go/comparison-of-identical-expressions`.
* The tag `external/cwe/cwe-783` has been added to `go/whitespace-contradicts-precedence`.
* The tag `external/cwe/cwe-835` has been added to `go/inconsistent-loop-direction`.
* The tag `error-handling` has been added to `go/missing-error-check`, `go/unhandled-writable-file-close`, and `go/unexpected-nil-value`.
* The tag `useless-code` has been added to `go/useless-assignment-to-field`, `go/useless-assignment-to-local`, `go/useless-expression`, and `go/unreachable-statement`.
* The tag `logic` has been removed from `go/index-out-of-bounds` and `go/unexpected-nil-value`.
* The tags `call` and `defer` have been removed from `go/unhandled-writable-file-close`.
* The tags `correctness` and `quality` have been reordered in `go/missing-error-check` and `go/unhandled-writable-file-close`.
* The tag `maintainability` has been changed to `reliability` for `go/unhandled-writable-file-close`.
* The tag order has been standardized to have `quality` first, followed by the top-level category (`reliability` or `maintainability`), then sub-category tags, and finally CWE tags.
* The description text has been updated in `go/whitespace-contradicts-precedence` to change "may even indicate" to "may indicate".

## 1.3.0

### New Queries

* Query (`go/html-template-escaping-bypass-xss`) has been promoted to the main query suite. This query finds potential cross-site scripting (XSS) vulnerabilities when using the `html/template` package, caused by user input being cast to a type which bypasses the HTML autoescaping. It was originally contributed to the experimental query pack by @gagliardetto in https://github.com/github/codeql-go/pull/493.

## 1.2.1

### Minor Analysis Improvements

* The query `go/hardcoded-credentials` has been removed from all query suites.

## 1.2.0

### Query Metadata Changes

* The tag `external/cwe/cwe-20` has been removed from `go/count-untrusted-data-external-api` and the tag `external/cwe/cwe-020` has been added.
* The tag `external/cwe/cwe-20` has been removed from `go/incomplete-hostname-regexp` and the tag `external/cwe/cwe-020` has been added.
* The tag `external/cwe/cwe-20` has been removed from `go/regex/missing-regexp-anchor` and the tag `external/cwe/cwe-020` has been added.
* The tag `external/cwe/cwe-20` has been removed from `go/suspicious-character-in-regex` and the tag `external/cwe/cwe-020` has been added.
* The tag `external/cwe/cwe-20` has been removed from `go/untrusted-data-to-external-api` and the tag `external/cwe/cwe-020` has been added.
* The tag `external/cwe/cwe-20` has been removed from `go/untrusted-data-to-unknown-external-api` and the tag `external/cwe/cwe-020` has been added.
* The tag `external/cwe/cwe-90` has been removed from `go/ldap-injection` and the tag `external/cwe/cwe-090` has been added.
* The tag `external/cwe/cwe-74` has been removed from `go/dsn-injection` and the tag `external/cwe/cwe-074` has been added.
* The tag `external/cwe/cwe-74` has been removed from `go/dsn-injection-local` and the tag `external/cwe/cwe-074` has been added.
* The tag `external/cwe/cwe-79` has been removed from `go/html-template-escaping-passthrough` and the tag `external/cwe/cwe-079` has been added.

## 1.1.13

No user-facing changes.

## 1.1.12

No user-facing changes.

## 1.1.11

### Minor Analysis Improvements

* False positives in "Log entries created from user input" (`go/log-injection`) and "Clear-text logging of sensitive information" (`go/clear-text-logging`) which involved the verb `%T` in a format specifier have been fixed. As a result, some users may also see more alerts from the "Use of constant `state` value in OAuth 2.0 URL" (`go/constant-oauth2-state`) query.

## 1.1.10

No user-facing changes.

## 1.1.9

No user-facing changes.

## 1.1.8

### Minor Analysis Improvements

* Added [github.com/gorilla/mux.Vars](https://pkg.go.dev/github.com/gorilla/mux#Vars) to path sanitizers (disabled if [github.com/gorilla/mix.Router.SkipClean](https://pkg.go.dev/github.com/gorilla/mux#Router.SkipClean) has been called).

## 1.1.7

No user-facing changes.

## 1.1.6

No user-facing changes.

## 1.1.5

No user-facing changes.

## 1.1.4

### Minor Analysis Improvements

* Added value flow models for functions in the `slices` package which do not involve the `iter` package.

## 1.1.3

No user-facing changes.

## 1.1.2

No user-facing changes.

## 1.1.1

No user-facing changes.

## 1.1.0

### Query Metadata Changes

* The precision of the `go/incorrect-integer-conversion-query` query was decreased from `very-high` to `high`, since there is at least one known class of false positives involving dynamic bounds checking.

## 1.0.8

No user-facing changes.

## 1.0.7

No user-facing changes.

## 1.0.6

No user-facing changes.

## 1.0.5

No user-facing changes.

## 1.0.4

No user-facing changes.

## 1.0.3

No user-facing changes.

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
