## 0.2.6

No user-facing changes.

## 0.2.5

### Minor Analysis Improvements

* The predicate `SummarizedCallable.propagatesFlow` has been extended with the columns `Provenance p` and `boolean isExact`, and as a consequence the predicates `SummarizedCallable.hasProvenance` and `SummarizedCallable.hasExactModel` have been removed.
* Added type inference support for the `FnMut(..) -> ..` and `Fn(..) -> ..` traits. They now work in type parameter bounds and are implemented by closures.

## 0.2.4

### Minor Analysis Improvements

* The `Deref` trait is now considered during method resolution. This means that method calls on receivers implementing the `Deref` trait will correctly resolve to methods defined on the target type. This may result in additional query results, especially for data flow queries.
* Renamed the `Adt` class to `TypeItem` and moved common predicates from `Struct`, `Enum`, and `Union` to `TypeItem`.
* Added models for the Axum web application framework.
* Reading content of a value now carries taint if the value itself is tainted. For instance, if `s` is tainted then `s.field` is also tainted. This generally improves taint flow.
* The call graph is now more precise for calls that target a trait function with a default implementation. This reduces the number of false positives for data flow queries.
* Improved type inference for raw pointers (`*const` and `*mut`). This includes type inference for the raw borrow operators (`&raw const` and `&raw mut`) and dereferencing of raw pointers.

## 0.2.3

No user-facing changes.

## 0.2.2

No user-facing changes.

## 0.2.1

No user-facing changes.

## 0.2.0

### Breaking Changes

* The type `DataFlow::Node` is now based directly on the AST instead of the CFG, which means that predicates like `asExpr()` return AST nodes instead of CFG nodes.

### Minor Analysis Improvements

* Added more detailed models for `std::fs` and `std::path`.

## 0.1.20

### Minor Analysis Improvements

* Added models for cookie methods in the `poem` crate.

## 0.1.19

### Major Analysis Improvements

* Resolution of calls to functions has been improved in a number of ways, to make it more aligned with the behavior of the Rust compiler. This may impact queries that rely on call resolution, such as data flow queries.
* Added basic models for the `actix-web` web framework.

### Minor Analysis Improvements

* Added `ExtractedFile::hasSemantics` and `ExtractedFile::isSkippedByCompilation` predicates.
* Generalized some existing models to improve data flow.
* Added models for the `mysql` and `mysql_async` libraries.

## 0.1.18

### New Features

* Rust analysis is now Generally Available (GA).

### Minor Analysis Improvements

* Improve data flow through functions being passed as function pointers. 

## 0.1.17

### New Features

* The models-as-data format for sources now supports access paths of the form
  `Argument[i].Parameter[j]`. This denotes that the source passes tainted data to
  the `j`th parameter of its `i`th argument (which must be a function or a
  closure).

## 0.1.16

### Minor Analysis Improvements

* Added cryptography related models for the `cookie` and `biscotti` crates.

## 0.1.15

### Major Analysis Improvements

* Path resolution has been removed from the Rust extractor. For the majority of purposes CodeQL computed paths have been in use for several previous releases, this completes the transition. Extraction is now faster and more reliable.

### Minor Analysis Improvements

* Attribute macros are now taken into account when identifying macro-expanded code. This affects the queries `rust/unused-variable` and `rust/unused-value`, which exclude results in macro-expanded code.
* Improved modelling of the `std::fs`, `async_std::fs` and `tokio::fs` libraries. This may cause more alerts to be found by Rust injection queries, particularly `rust/path-injection`.

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
