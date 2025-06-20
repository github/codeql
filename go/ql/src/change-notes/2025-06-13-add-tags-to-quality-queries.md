---
category: queryMetadata
---
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
