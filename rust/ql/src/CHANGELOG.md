## 0.1.27

No user-facing changes.

## 0.1.26

No user-facing changes.

## 0.1.25

### Minor Analysis Improvements

* Fixed common false positives for the `rust/unused-variable` and `rust/unused-value` queries.
* Fixed false positives from the `rust/access-invalid-pointer` query, by only considering dereferences of raw pointers as sinks.
* Fixed false positives from the `rust/access-after-lifetime-ended` query, involving calls to trait methods.
* The `rust/hard-coded-cryptographic-value` query has been extended with new heuristic sinks identifying passwords, initialization vectors, nonces and salts.

## 0.1.24

No user-facing changes.

## 0.1.23

No user-facing changes.

## 0.1.22

No user-facing changes.

## 0.1.21

### New Queries

* Added a new query `rust/xss`, to detect cross-site scripting security vulnerabilities.
* Added a new query `rust/disabled-certificate-check`, to detect disabled TLS certificate checks.
* Added three example queries (`rust/examples/empty-if`, `rust/examples/simple-sql-injection` and `rust/examples/simple-constant-password`) to help developers learn to write CodeQL queries for Rust.

### Minor Analysis Improvements

* The `rust/access-invalid-pointer` query has been improved with new flow sources and barriers.

## 0.1.20

### Minor Analysis Improvements

* Taint flow barriers have been added to the `rust/regex-injection`, `rust/sql-injection` and `rust/log-injection`, reducing the frequency of false positive results for these queries.

## 0.1.19

### Minor Analysis Improvements

* The "Low Rust analysis quality" query (`rust/diagnostic/database-quality`), used by the tool status page, has been extended with a measure of successful type inference.

## 0.1.18

### New Queries

* Added a new query, `rust/insecure-cookie`, to detect cookies created without the 'Secure' attribute.

## 0.1.17

### New Queries

* Added a new query, `rust/non-https-url`, for detecting the use of non-HTTPS URLs that can be intercepted by third parties.

## 0.1.16

### New Queries

* Added a new query, `rust/request-forgery`, for detecting server-side request forgery vulnerabilities.

### Bug Fixes

* The message for `rust/diagnostic/database-quality` has been updated to include detailed database health metrics. These changes are visible on the tool status page.

## 0.1.15

### New Queries

* Added a new query, `rust/log-injection`, for detecting cases where log entries could be forged by a malicious user.

### Bug Fixes

* The "Low Rust analysis quality" query (`rust/diagnostic/database-quality`) has been tuned so that it won't trigger on databases that have extracted normally. This will remove spurious messages of "Low Rust analysis quality" on the CodeQL status page.
* Fixed an inconsistency across languages where most have a `Customizations.qll` file for adding customizations, but not all did.

## 0.1.14

### New Queries

* Added a new query, `rust/cleartext-storage-database`, for detecting cases where sensitive information is stored non-encrypted in a database.

## 0.1.13

### New Queries

* Added a new query, `rust/hard-coded-cryptographic-value`, for detecting use of hardcoded keys, passwords, salts and initialization vectors.

### Minor Analysis Improvements

* Type inference now supports closures, calls to closures, and trait bounds
  using the `FnOnce` trait.
* Type inference now supports trait objects, i.e., `dyn Trait` types.
* Type inference now supports tuple types.

## 0.1.12

### New Queries

* Added a new query, `rust/access-after-lifetime-ended`, for detecting pointer dereferences after the lifetime of the pointed-to object has ended.

## 0.1.11

### New Queries

* Initial public preview release.

## 0.1.10

No user-facing changes.

## 0.1.9

No user-facing changes.

## 0.1.8

No user-facing changes.

## 0.1.7

### Minor Analysis Improvements

* Changes to the MaD model generation infrastructure:
  * Changed the query `rust/utils/modelgenerator/summary-models` to use the implementation from `rust/utils/modelgenerator/mixed-summary-models`.
  * Removed the now-redundant `rust/utils/modelgenerator/mixed-summary-models` query.
  * A similar replacement was made for `rust/utils/modelgenerator/neutral-models`. That is, if `GenerateFlowModel.py` is provided with `--with-summaries`, combined/mixed models are now generated instead of heuristic models (and similar for `--with-neutrals`).

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
