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
