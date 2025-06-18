---
category: queryMetadata
---
* The tag `quality` has been added to multiple Java quality queries for consistency. They have all been given a tag for one of the two top-level categories `reliability` or `maintainability`, and a tag for a sub-category. See [Query file metadata and alert message style guide](https://github.com/github/codeql/blob/main/docs/query-metadata-style-guide.md#quality-query-sub-category-tags) for more information about these categories.
* The tag `external/cwe/cwe-571` has been added to `java/equals-on-unrelated-types`.
* The tag `readability` has been added to `java/missing-override-annotation`, `java/deprecated-call`, `java/inconsistent-javadoc-throws`, `java/unknown-javadoc-parameter`, `java/jdk-internal-api-access`, `java/underscore-identifier`, `java/misleading-indentation`, `java/inefficient-empty-string-test`, `java/non-static-nested-class`, `inefficient-string-constructor`, and `java/constants-only-interface`.
* The tag `useless-code` has been added to `java/useless-type-test`, and `java/useless-tostring-call`.
* The tag `complexity` has been added to `java/chained-type-tests`, and `java/abstract-to-concrete-cast`.
* The tag `error-handling` has been added to `java/ignored-error-status-of-call`, and `java/uncaught-number-format-exception`.
* The tag `correctness` has been added to `java/evaluation-to-constant`, `java/whitespace-contradicts-precedence`, `java/empty-container`, `java/string-buffer-char-init`, `java/call-to-object-tostring`, `java/print-array` and `java/internal-representation-exposure`.
* The tag `performance` has been added to `java/input-resource-leak`, `java/database-resource-leak`, `java/output-resource-leak`, `java/inefficient-key-set-iterator`, `java/inefficient-output-stream`, and `java/inefficient-boxed-constructor`.
* The tag `correctness` has been removed from `java/call-to-thread-run`, `java/unsafe-double-checked-locking`, `java/unsafe-double-checked-locking-init-order`, `java/non-sync-override`, `java/sync-on-boxed-types`, `java/unsynchronized-getter`, `java/input-resource-leak`, `java/output-resource-leak`, `java/database-resource-leak`, and `java/ignored-error-status-of-call`.
* The tags `maintainability` has been removed from `java/string-buffer-char-init`, `java/inefficient-key-set-iterator`, `java/inefficient-boxed-constructor`, and `java/internal-representation-exposure`.
* The tags `reliability` has been removed from `java/subtle-inherited-call`, `java/print-array`, and `java/call-to-object-tostring`.
* The tags `maintainability` and `useless-code` have been removed from `java/evaluation-to-constant`.
* The tags `maintainability` and `readability` have been removed from `java/whitespace-contradicts-precedence`.
* The tags `maintainability` and `useless-code` have been removed from `java/empty-container`.
