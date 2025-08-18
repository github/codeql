## 0.1.14

### Minor Analysis Improvements

* [`let` chains in `if` and `while`](https://doc.rust-lang.org/edition-guide/rust-2024/let-chains.html) are now supported, as well as [`if let` guards in `match` expressions](https://rust-lang.github.io/rfcs/2294-if-let-guard.html).
* Added more detail to models of `postgres`, `rusqlite`, `sqlx` and `tokio-postgres`. This may improve query results, particularly for `rust/sql-injection` and `rust/cleartext-storage-database`.

## 0.1.13

### Minor Analysis Improvements

* Removed deprecated dataflow extensible predicates `sourceModelDeprecated`, `sinkModelDeprecated`, and `summaryModelDeprecated`, along with their associated classes.
* The regular expressions in `SensitiveDataHeuristics.qll` have been extended to find more instances of sensitive data such as secrets used in authentication, finance and health information, and device data. The heuristics have also been refined to find fewer false positive matches. This will improve results for queries related to sensitive information.

## 0.1.12

### Minor Analysis Improvements

* Type inference has been extended to support pattern matching.
* Call resolution for calls to associated functions has been improved, so it now disambiguates the targets based on type information at the call sites (either type information about the arguments or about the expected return types).
* Type inference has been improved for `for` loops and range expressions, which improves call resolution and may ultimately lead to more query results.
* Implemented support for data flow through trait functions. For the purpose of data flow, calls to trait functions dispatch to all possible implementations.
* `AssocItem` and `ExternItem` are now proper subclasses of `Item`.
* Added type inference for `for` loops and array expressions.

## 0.1.11

### New Features

* Initial public preview release.

## 0.1.10

No user-facing changes.

## 0.1.9

No user-facing changes.

## 0.1.8

No user-facing changes.

## 0.1.7

No user-facing changes.

## 0.1.6

No user-facing changes.

## 0.1.5

No user-facing changes.

## 0.1.4

No user-facing changes.

## 0.1.3

No user-facing changes.

## 0.1.2

No user-facing changes.

## 0.1.1

No user-facing changes.

## 0.1.0

No user-facing changes.
