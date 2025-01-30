## 1.0.15

No user-facing changes.

## 1.0.14

No user-facing changes.

## 1.0.13

No user-facing changes.

## 1.0.12

No user-facing changes.

## 1.0.11

No user-facing changes.

## 1.0.10

No user-facing changes.

## 1.0.9

No user-facing changes.

## 1.0.8

No user-facing changes.

## 1.0.7

No user-facing changes.

## 1.0.6

### Minor Analysis Improvements

* False positive results from the `swift/cleartext-transmission` ("Cleartext transmission of sensitive information") query involving `tel:`, `mailto:` and similar URLs have been fixed.

## 1.0.5

### Minor Analysis Improvements

* The `swift/constant-salt` ("Use of constant salts") query now considers string concatenation and interpolation as a barrier. As a result, there will be fewer false positive results from this query involving constructed strings.
* The `swift/constant-salt` ("Use of constant salts") query message now contains a link to the source node.

## 1.0.4

No user-facing changes.

## 1.0.3

No user-facing changes.

## 1.0.2

No user-facing changes.

## 1.0.1

No user-facing changes.

## 1.0.0

### Breaking Changes

* CodeQL package management is now generally available, and all GitHub-produced CodeQL packages have had their version numbers increased to 1.0.0.

## 0.3.16

No user-facing changes.

## 0.3.15

No user-facing changes.

## 0.3.14

No user-facing changes.

## 0.3.13

No user-facing changes.

## 0.3.12

No user-facing changes.

## 0.3.11

No user-facing changes.

## 0.3.10

No user-facing changes.

## 0.3.9

### New Queries

* Added a new experimental query, `swift/unsafe-unpacking`, that detects unpacking user controlled zips without validating the destination file path is within the destination directory.

## 0.3.8

No user-facing changes.

## 0.3.7

### New Queries

* Added new query "Use of an inappropriate cryptographic hashing algorithm on passwords" (`swift/weak-password-hashing`). This query detects use of inappropriate hashing algorithms for password hashing. Some of the results of this query are new, others would previously have been reported by the "Use of a broken or weak cryptographic hashing algorithm on sensitive data" (`swift/weak-sensitive-data-hashing`) query.

### Minor Analysis Improvements

* The diagnostic query `swift/diagnostics/successfully-extracted-files` now considers any Swift file seen during extraction, even one with some errors, to be extracted / scanned. This affects the Code Scanning UI measure of scanned Swift files.

## 0.3.6

### Minor Analysis Improvements

* Added additional sinks for the "Cleartext logging of sensitive information" (`swift/cleartext-logging`) query. Some of these sinks are heuristic (imprecise) in nature.

## 0.3.5

No user-facing changes.

## 0.3.4

### Minor Analysis Improvements

* Added additional sinks for the "Uncontrolled format string" (`swift/uncontrolled-format-string`) query. Some of these sinks are heuristic (imprecise) in nature.
* Added heuristic (imprecise) sinks for the "Database query built from user-controlled sources" (`swift/sql-injection`) query.

## 0.3.3

### New Queries

* Added new query "System command built from user-controlled sources" (`swift/command-line-injection`) for Swift. This query detects system commands built from user-controlled sources without sufficient validation. The query was previously [contributed to the 'experimental' directory by @maikypedia](https://github.com/github/codeql/pull/13726) but will now run by default for all code scanning users.
* Added a new query "Missing regular expression anchor" (`swift/missing-regexp-anchor`) for Swift. This query detects regular expressions without anchors that can be vulnerable to bypassing.

### Minor Analysis Improvements

* Added additional sinks for the "Uncontrolled data used in path expression" (`swift/path-injection`) query. Some of these sinks are heuristic (imprecise) in nature.
* Fixed an issue where some Realm database sinks were not being recognized for the `swift/cleartext-storage-database` query.

## 0.3.2

No user-facing changes.

## 0.3.1

### Minor Analysis Improvements

* Added more new logging sinks to the `swift/cleartext-logging` query.
* Added sinks for the GRDB database library to the `swift/hardcoded-key` query.
* Added sqlite3 and SQLite.swift sinks and flow summaries for the `swift/hardcoded-key` query.
* Added sqlite3 and SQLite.swift sinks and flow summaries for the `swift/cleartext-storage-database` query.

## 0.3.0

### Minor Analysis Improvements

* Adder barriers for numeric type values to the injection-like queries, to reduce false positive results where the user input that can be injected is constrainted to a numerical value. The queries updated by this change are: "Predicate built from user-controlled sources" (`swift/predicate-injection`), "Database query built from user-controlled sources" (`swift/sql-injection`), "Uncontrolled format string" (`swift/uncontrolled-format-string`), "JavaScript Injection" (`swift/unsafe-js-eval`) and "Regular expression injection" (`swift/regex-injection`).
* Added additional taint steps to the `swift/cleartext-transmission`, `swift/cleartext-logging` and `swift/cleartext-storage-preferences` queries to identify data within sensitive containers. This is similar to an existing additional taint step in the `swift/cleartext-storage-database` query.
* Added new logging sinks to the `swift/cleartext-logging` query.
* Added sqlite3 and SQLite.swift path injection sinks for the `swift/path-injection` query.

## 0.2.5

No user-facing changes.

## 0.2.4

### New Queries

* Added new query "Incomplete regular expression for hostnames" (`swift/incomplete-hostname-regexp`). This query finds regular expressions matching a URL or hostname that may match more hostnames than expected.

## 0.2.3

No user-facing changes.

## 0.2.2

### New Queries

* Added new query "Command injection" (`swift/command-line-injection`). The query finds places where user input is used to execute system commands without proper escaping.
* Added new query "Bad HTML filtering regexp" (`swift/bad-tag-filter`). This query finds regular expressions that match HTML tags in a way that is not robust and can easily lead to security issues.

## 0.2.1

### New Queries

* Added new query "Regular expression injection" (`swift/regex-injection`). The query finds places where user input is used to construct a regular expression without proper escaping.
* Added new query "Inefficient regular expression" (`swift/redos`). This query finds regular expressions that require exponential time to match certain inputs and may make an application vulnerable to denial-of-service attacks.

## 0.2.0

### Bug Fixes

* Functions and methods modeled as flow summaries are no longer shown in the path of `path-problem` queries. This results in more succinct paths for most security queries.

## 0.1.2

No user-facing changes.

## 0.1.1

### Minor Analysis Improvements

* Fixed some false positive results from the `swift/string-length-conflation` query, caused by imprecise sinks.
