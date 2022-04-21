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
