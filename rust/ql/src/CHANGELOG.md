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
