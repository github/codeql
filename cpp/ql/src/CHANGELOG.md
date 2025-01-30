## 1.3.2

### Minor Analysis Improvements

* Added dataflow models for `SysAllocString` and related functions.
* The `cpp/badly-bounded-write`, `cpp/equality-on-floats`, `cpp/short-global-name`, `cpp/static-buffer-overflow`, `cpp/too-few-arguments`, `cpp/useless-expression`, `cpp/world-writable-file-creation` queries no longer produce alerts on files created by CMake to test the build configuration.

## 1.3.1

### Minor Analysis Improvements

* The "Returning stack-allocated memory" query (`cpp/return-stack-allocated-memory`) no longer produces results if there is an extraction error in the returned expression.
* The "Badly bounded write" query (`cpp/badly-bounded-write`) no longer produces results if there is an extraction error in the type of the output buffer.
* The "Too few arguments to formatting function" query (`cpp/wrong-number-format-arguments`) no longer produces results if an argument has an extraction error.
* The "Wrong type of arguments to formatting function" query (`cpp/wrong-type-format-argument`) no longer produces results when an argument type has an extraction error.
* Added dataflow models and flow sources for Microsoft's Active Template Library (ATL).

## 1.3.0

### New Queries

* Added a new high-precision quality query, `cpp/guarded-free`, which detects useless NULL pointer checks before calls to `free`. A variation of this query was originally contributed as an [experimental query by @mario-campos](https://github.com/github/codeql/pull/16331).

### Minor Analysis Improvements

* The "Call to function with fewer arguments than declared parameters" query (`cpp/too-few-arguments`) no longer produces results if the function has been implicitly declared.

## 1.2.7

No user-facing changes.

## 1.2.6

### Minor Analysis Improvements

* Remove results from the `cpp/wrong-type-format-argument` ("Wrong type of arguments to formatting function") query if the argument is the return value of an implicitly declared function.

## 1.2.5

### Minor Analysis Improvements

* The `cpp/unclear-array-index-validation` ("Unclear validation of array index") query has been improved to reduce false positives and increase true positives.
* Fixed false positives in the `cpp/uninitialized-local` ("Potentially uninitialized local variable") query if there are extraction errors in the function.
* The `cpp/incorrect-string-type-conversion` query now produces fewer false positives caused by failure to detect byte arrays.
* The `cpp/incorrect-string-type-conversion` query now produces fewer false positives caused by failure to recognize dynamic checks prior to possible dangerous widening.

## 1.2.4

### Minor Analysis Improvements

* Fixed false positives in the `cpp/wrong-number-format-arguments` ("Too few arguments to formatting function") query when the formatting function has been declared implicitly.

## 1.2.3

### Minor Analysis Improvements

* Removed false positives caused by buffer accesses in unreachable code
* Removed false positives caused by inconsistent type checking
* Add modeling of C functions that don't throw, thereby increasing the precision of the `cpp/incorrect-allocation-error-handling` ("Incorrect allocation-error handling") query. The query now produces additional true positives.

## 1.2.2

No user-facing changes.

## 1.2.1

### Minor Analysis Improvements

* The `cpp/uncontrolled-allocation-size` ("Uncontrolled allocation size") query now considers arithmetic operations that might reduce the size of user input as a barrier. The query therefore produces fewer false positive results.

## 1.2.0

### Query Metadata Changes

* The precision of `cpp/unsigned-difference-expression-compared-zero` ("Unsigned difference expression compared to zero") has been increased to `high`. As a result, it will be run by default as part of the Code Scanning suite.

### Minor Analysis Improvements

* Fixed false positives in the `cpp/memory-may-not-be-freed` ("Memory may not be freed") query involving class methods that returned an allocated field of that class being misidentified as allocators.
* The `cpp/incorrectly-checked-scanf` ("Incorrect return-value check for a 'scanf'-like function") query now produces fewer false positive results.
* The `cpp/incorrect-allocation-error-handling` ("Incorrect allocation-error handling") query no longer produces occasional false positive results inside template instantiations.
* The `cpp/suspicious-allocation-size` ("Not enough memory allocated for array of pointer type") query no longer produces false positives on "variable size" `struct`s.

## 1.1.0

### Query Metadata Changes

* The precision of `cpp/iterator-to-expired-container` ("Iterator to expired container") has been increased to `high`. As a result, it will be run by default as part of the Code Scanning suite.
* The precision of `cpp/unsafe-strncat` ("Potentially unsafe call to strncat") has been increased to `high`. As a result, it will be run by default as part of the Code Scanning suite.

### Minor Analysis Improvements

* The `cpp/unsigned-difference-expression-compared-zero` ("Unsigned difference expression compared to zero") query now produces fewer false positives.

## 1.0.3

No user-facing changes.

## 1.0.2

No user-facing changes.

## 1.0.1

### Minor Analysis Improvements

* The `cpp/dangerous-function-overflow` no longer produces a false positive alert when the `gets` function does not have exactly one parameter.

## 1.0.0

### Breaking Changes

* CodeQL package management is now generally available, and all GitHub-produced CodeQL packages have had their version numbers increased to 1.0.0.

### Minor Analysis Improvements

* The "Use of unique pointer after lifetime ends" query (`cpp/use-of-unique-pointer-after-lifetime-ends`) no longer reports an alert when the pointer is converted to a boolean
* The "Variable not initialized before use" query (`cpp/not-initialised`) no longer reports an alert on static variables.

## 0.9.12

### New Queries

* Added a new query, `cpp/iterator-to-expired-container`, to detect the creation of iterators owned by a temporary objects that are about to be destroyed.

## 0.9.11

### Minor Analysis Improvements

* The "Uncontrolled data used in path expression" query (`cpp/path-injection`) query produces fewer near-duplicate results.
* The "Global variable may be used before initialization" query (`cpp/global-use-before-init`) no longer raises an alert on global variables that are initialized when they are declared.
* The "Inconsistent null check of pointer" query (`cpp/inconsistent-nullness-testing`) query no longer raises an alert when the guarded check is in a macro expansion.

## 0.9.10

No user-facing changes.

## 0.9.9

### New Queries

* Added a new query, `cpp/type-confusion`, to detect casts to invalid types.

### Query Metadata Changes

* `@precision medium` metadata was added to the `cpp/boost/tls-settings-misconfiguration` and `cpp/boost/use-of-deprecated-hardcoded-security-protocol` queries, and these queries are now included in the security-extended suite. The `@name` metadata of these queries were also updated.

### Minor Analysis Improvements

* The "Missing return-value check for a 'scanf'-like function" query (`cpp/missing-check-scanf`) has been converted to a `path-problem` query.
* The "Potentially uninitialized local variable" query (`cpp/uninitialized-local`) has been converted to a `path-problem` query.
* Added models for `GLib` allocation and deallocation functions.

## 0.9.8

No user-facing changes.

## 0.9.7

No user-facing changes.

## 0.9.6

### Minor Analysis Improvements

* The "non-constant format string" query (`cpp/non-constant-format`) has been converted to a `path-problem` query.
* The new C/C++ dataflow and taint-tracking libraries (`semmle.code.cpp.dataflow.new.DataFlow` and `semmle.code.cpp.dataflow.new.TaintTracking`) now implicitly assume that dataflow and taint modelled via `DataFlowFunction` and `TaintFunction` always fully overwrite their buffers and thus act as flow barriers. As a result, many dataflow and taint-tracking queries now produce fewer false positives. To remove this assumption and go back to the previous behavior for a given model, one can override the new `isPartialWrite` predicate.

## 0.9.5

### Minor Analysis Improvements

* The "non-constant format string" query (`cpp/non-constant-format`) has been updated to produce fewer false positives.
* Added dataflow models for the `gettext` function variants. 

## 0.9.4

### Minor Analysis Improvements

* Corrected 2 false positive with `cpp/incorrect-string-type-conversion`: conversion of byte arrays to wchar and new array allocations converted to wchar.
* The "Incorrect return-value check for a 'scanf'-like function" query (`cpp/incorrectly-checked-scanf`) no longer reports an alert when an explicit check for EOF is added.
* The "Incorrect return-value check for a 'scanf'-like function" query (`cpp/incorrectly-checked-scanf`) now recognizes more EOF checks.
* The "Potentially uninitialized local variable" query (`cpp/uninitialized-local`) no longer reports an alert when the local variable is used as a qualifier to a static member function call.
* The diagnostic query `cpp/diagnostics/successfully-extracted-files` now considers any C/C++ file seen during extraction, even one with some errors, to be extracted / scanned. This affects the Code Scanning UI measure of scanned C/C++ files.

## 0.9.3

### Minor Analysis Improvements

* The `cpp/include-non-header` style query will now ignore the `.def` extension for textual header inclusions.

## 0.9.2

### New Queries

* Added a new query, `cpp/use-of-unique-pointer-after-lifetime-ends`, to detect uses of the contents unique pointers that will be destroyed immediately.
* The `cpp/incorrectly-checked-scanf` query has been added. This finds results where the return value of scanf is not checked correctly. Some of these were previously found by `cpp/missing-check-scanf` and will no longer be reported there.

### Minor Analysis Improvements

* The `cpp/badly-bounded-write` query could report false positives when a pointer was first initialized with a literal and later assigned a dynamically allocated array. These false positives now no longer occur.

## 0.9.1

No user-facing changes.

## 0.9.0

### Breaking Changes

* The `cpp/tainted-format-string-through-global` query has been deleted. This does not lead to a loss of relevant alerts, as the query duplicated a subset of the alerts from `cpp/tainted-format-string`.

### New Queries

* Added a new query, `cpp/use-of-string-after-lifetime-ends`, to detect calls to `c_str` on strings that will be destroyed immediately.

## 0.8.3

### Minor Analysis Improvements

* The `cpp/uninitialized-local` query has been improved to produce fewer false positives.

## 0.8.2

No user-facing changes.

## 0.8.1

### New Queries

* The query `cpp/redundant-null-check-simple` has been promoted to Code Scanning. The query finds cases where a pointer is compared to null after it has already been dereferenced. Such comparisons likely indicate a bug at the place where the pointer is dereferenced, or where the pointer is compared to null.

  Note: This query was incorrectly noted as being promoted to Code Scanning in CodeQL version 2.14.6.

## 0.8.0

### Query Metadata Changes

* The `cpp/double-free` query has been further improved to reduce false positives and its precision has been increased from `medium` to `high`.
* The `cpp/use-after-free` query has been further improved to reduce false positives and its precision has been increased from `medium` to `high`.

### Minor Analysis Improvements

* The queries `cpp/double-free` and `cpp/use-after-free` find fewer false positives
  in cases where a non-returning function is called.
* The number of duplicated dataflow paths reported by queries has been significantly reduced.

## 0.7.5

No user-facing changes.

## 0.7.4

### New Queries

* Added a new query, `cpp/invalid-pointer-deref`, to detect out-of-bounds pointer reads and writes.

### Minor Analysis Improvements

* The "Comparison where assignment was intended" query (`cpp/compare-where-assign-meant`) no longer reports comparisons that appear in macro expansions.
* Some queries that had repeated results corresponding to different levels of indirection for `argv` now only have a single result.
* The `cpp/non-constant-format` query no longer considers an assignment on the right-hand side of another assignment to be a source of non-constant format strings. As a result, the query may now produce fewer results.

## 0.7.3

No user-facing changes.

## 0.7.2

No user-facing changes.

## 0.7.1

### Minor Analysis Improvements

* The `cpp/uninitialized-local` query now excludes uninitialized uses that are explicitly cast to void and are expression statements. As a result, the query will report less false positives.

## 0.7.0

### Minor Analysis Improvements

* The `cpp/comparison-with-wider-type` query now correctly handles relational operations on signed operators. As a result the query may find more results.

## 0.6.4

No user-facing changes.

## 0.6.3

### New Queries

* Added a new query, `cpp/overrun-write`, to detect buffer overflows in C-style functions that manipulate buffers.

## 0.6.2

No user-facing changes.

## 0.6.1

### New Queries

* A new query `cpp/double-free` has been added. The query finds possible cases of deallocating the same pointer twice. The precision of the query has been set to "medium".
* The query `cpp/use-after-free` has been modernized and assigned the precision "medium". The query finds cases of where a pointer is dereferenced after its memory has been deallocated.

## 0.6.0

### New Queries

* The query `cpp/redundant-null-check-simple` has been promoted to Code Scanning. The query finds cases where a pointer is compared to null after it has already been dereferenced. Such comparisons likely indicate a bug at the place where the pointer is dereferenced, or where the pointer is compared to null.

### Minor Analysis Improvements

* The query `cpp/tainted-arithmetic` now also flags possible overflows in arithmetic assignment operations.

## 0.5.6

No user-facing changes.

## 0.5.5

### Deprecated Queries

* The `NetworkToBufferSizeConfiguration` and `UntrustedDataToExternalApiConfig` dataflow configurations have been deprecated. Please use `NetworkToBufferSizeFlow` and `UntrustedDataToExternalApiFlow`.
* The `LeapYearCheckConfiguration`, `FiletimeYearArithmeticOperationCheckConfiguration`, and `PossibleYearArithmeticOperationCheckConfiguration` dataflow configurations have been deprecated. Please use `LeapYearCheckFlow`, `FiletimeYearArithmeticOperationCheckFlow` and `PossibleYearArithmeticOperationCheckFlow`.

## 0.5.4

No user-facing changes.

## 0.5.3

No user-facing changes.

## 0.5.2

No user-facing changes.

## 0.5.1

### Minor Analysis Improvements

* The `cpp/no-space-for-terminator` and `cpp/uncontrolled-allocation-size` queries have been enhanced with heuristic detection of allocations. These queries now find more results.

## 0.5.0

### Minor Analysis Improvements

* The `AlertSuppression.ql` query has been updated to support the new `// codeql[query-id]` supression comments. These comments can be used to suppress an alert and must be placed on a blank line before the alert. In addition the legacy `// lgtm` and `// lgtm[query-id]` comments can now also be placed on the line before an alert.
* The `cpp/missing-check-scanf` query no longer reports the free'ing of `scanf` output variables as potential reads.

## 0.4.6

No user-facing changes.

## 0.4.5

No user-facing changes.

## 0.4.4

No user-facing changes.

## 0.4.3

### Minor Analysis Improvements

* Fixed a bug in `cpp/jsf/av-rule-76` that caused the query to miss results when an implicitly-defined copy constructor or copy assignment operator was generated.

## 0.4.2

### New Queries

* Added a new medium-precision query, `cpp/comma-before-misleading-indentation`, which detects instances of whitespace that have readability issues.

### Minor Analysis Improvements

* The "Unterminated variadic call" (`cpp/unterminated-variadic-call`) query has been tuned to produce fewer false positive results.
* Fixed false positives from the "Unused static function" (`cpp/unused-static-function`) query in files that had errors during compilation.

## 0.4.1

### Minor Analysis Improvements

* The alert message of many queries have been changed to better follow the style guide and make the message consistent with other languages.

## 0.4.0

### New Queries

* Added a new medium-precision query, `cpp/missing-check-scanf`, which detects `scanf` output variables that are used without a proper return-value check to see that they were actually written. A variation of this query was originally contributed as an [experimental query by @ihsinme](https://github.com/github/codeql/pull/8246).

### Minor Analysis Improvements

* Modernizations from "Cleartext storage of sensitive information in buffer" (`cpp/cleartext-storage-buffer`) have been ported to the "Cleartext storage of sensitive information in file" (`cpp/cleartext-storage-file`), "Cleartext transmission of sensitive information" (`cpp/cleartext-transmission`) and "Cleartext storage of sensitive information in an SQLite database" (`cpp/cleartext-storage-database`) queries. These changes may result in more correct results and fewer false positive results from these queries.
* The alert message of many queries have been changed to make the message consistent with other languages.

## 0.3.4

## 0.3.3

### Minor Analysis Improvements

* The "Cleartext storage of sensitive information in buffer" (`cpp/cleartext-storage-buffer`) query has been improved to produce fewer false positives.

## 0.3.2

### Minor Analysis Improvements

* The query `cpp/bad-strncpy-size` now covers more `strncpy`-like functions than before, including `strxfrm`(`_l`), `wcsxfrm`(`_l`), and `stpncpy`. Users of this query may see an increase in results.

## 0.3.1

## 0.3.0

### Breaking Changes

* Contextual queries and the query libraries they depend on have been moved to the `codeql/cpp-all` package.

## 0.2.0

## 0.1.4

## 0.1.3

### Minor Analysis Improvements

* The "XML external entity expansion" (`cpp/external-entity-expansion`) query precision has been increased to `high`.
* The `cpp/unused-local-variable` no longer ignores functions that include `if` and `switch` statements with C++17-style initializers.

## 0.1.2

### Minor Analysis Improvements

* The "XML external entity expansion" (`cpp/external-entity-expansion`) query has been extended to support a broader selection of XML libraries and interfaces.

## 0.1.1

### New Queries

* An new query `cpp/external-entity-expansion` has been added. The query detects XML objects that are vulnerable to external entity expansion (XXE) attacks.

## 0.1.0

### Minor Analysis Improvements

* The `cpp/cleartext-transmission` query now recognizes additional sources, for sensitive private data such as e-mail addresses and credit card numbers.
* The `cpp/unused-local-variable` no longer ignores functions that include lambda expressions capturing trivially copyable objects.
* The `cpp/command-line-injection` query now takes into account calling contexts across string concatenations. This removes false positives due to mismatched calling contexts before and after string concatenations.
* A new query, "Potential exposure of sensitive system data to an unauthorized control sphere" (`cpp/potential-system-data-exposure`) has been added. This query is focused on exposure of information that is highly likely to be sensitive, whereas the similar query "Exposure of system data to an unauthorized control sphere" (`cpp/system-data-exposure`) is focused on exposure of information on a channel that is more likely to be intercepted by an attacker.

## 0.0.13

## 0.0.12

### Minor Analysis Improvements

* The `cpp/overflow-destination`, `cpp/unclear-array-index-validation`, and `cpp/uncontrolled-allocation-size` queries have been modernized and converted to `path-problem` queries and provide more true positive results.
* The `cpp/system-data-exposure` query has been increased from `medium` to `high` precision, following a number of improvements to the query logic.

## 0.0.11

### Breaking Changes

* The deprecated queries `cpp/duplicate-block`, `cpp/duplicate-function`, `cpp/duplicate-class`, `cpp/duplicate-file`, `cpp/mostly-duplicate-function`,`cpp/similar-file`, `cpp/duplicated-lines-in-files` have been removed.

### Deprecated Predicates and Classes

* The predicates and classes in the `CodeDuplication` library have been deprecated.

### New Queries

* A new query titled "Use of expired stack-address" (`cpp/using-expired-stack-address`) has been added.
  This query finds accesses to expired stack-allocated memory that escaped via a global variable.
* A new `cpp/insufficient-key-size` query has been added to the default query suite for C/C++. The query finds uses of certain cryptographic algorithms where the key size is too small to provide adequate encryption strength.

### Minor Analysis Improvements

* The "Failure to use HTTPS URLs" (`cpp/non-https-url`) has been improved reducing false positive results, and its precision has been increased to 'high'.
* The `cpp/system-data-exposure` query has been modernized and has converted to a `path-problem` query. There are now fewer false positive results.

## 0.0.10

### Deprecated Classes

* The `CodeDuplication.Copy`, `CodeDuplication.DuplicateBlock`, and `CodeDuplication.SimilarBlock` classes have been deprecated.

## 0.0.9

### New Queries

* Added a new query, `cpp/open-call-with-mode-argument`, to detect when `open` or `openat` is called with the `O_CREAT` or `O_TMPFILE` flag but when the `mode` argument is omitted.

### Minor Analysis Improvements

* The "Cleartext transmission of sensitive information" (`cpp/cleartext-transmission`) query has been further improved to reduce false positive results, and upgraded from `medium` to `high` precision.
* The "Cleartext transmission of sensitive information" (`cpp/cleartext-transmission`) query now finds more results, where a password is stored in a struct field or class member variable.
* The `cpp/cleartext-storage-file` query has been improved, removing false positives where data is written to a standard output stream.
* The `cpp/cleartext-storage-buffer` query has been updated to use the `semmle.code.cpp.dataflow.TaintTracking` library.
* The `cpp/world-writable-file-creation` query now only detects `open` and `openat` calls with the `O_CREAT` or `O_TMPFILE` flag.

## 0.0.8

### New Queries

* The `security` tag has been added to the `cpp/return-stack-allocated-memory` query. As a result, its results will now appear by default.
* The "Uncontrolled data in arithmetic expression" (cpp/uncontrolled-arithmetic) query has been enhanced to reduce false positive results and its @precision increased to high.
* A new `cpp/very-likely-overrunning-write` query has been added to the default query suite for C/C++. The query reports some results that were formerly flagged by `cpp/overrunning-write`.

### Minor Analysis Improvements

* Fix an issue with the `cpp/declaration-hides-variable` query where it would report variables that are unnamed in a database.
* The `cpp/cleartext-storage-file` query has been upgraded with non-local taint flow and has been converted to a `path-problem` query.
* The `cpp/return-stack-allocated-memory` query has been improved to produce fewer false positives. The
  query has also been converted to a `path-problem` query.
* The "Cleartext transmission of sensitive information" (`cpp/cleartext-transmission`) query has been improved in several ways to reduce false positive results.
* The "Potential improper null termination" (`cpp/improper-null-termination`) query now produces fewer false positive results around control flow branches and loops.
* Added exception for GLib's gboolean to cpp/ambiguously-signed-bit-field.
  This change reduces the number of false positives in the query.

## 0.0.7

## 0.0.6

## 0.0.5

### New Queries

* A new query `cpp/certificate-not-checked` has been added for C/C++. The query flags unsafe use of OpenSSL and similar libraries.
* A new query `cpp/certificate-result-conflation` has been added for C/C++. The query flags unsafe use of OpenSSL and similar libraries.

## 0.0.4

### New Queries

* A new query `cpp/non-https-url` has been added for C/C++. The query flags uses of `http` URLs that might be better replaced with `https`.
