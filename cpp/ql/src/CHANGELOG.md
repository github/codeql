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
* A new `cpp/very-likely-overruning-write` query has been added to the default query suite for C/C++. The query reports some results that were formerly flagged by `cpp/overruning-write`.

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
