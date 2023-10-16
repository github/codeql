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
