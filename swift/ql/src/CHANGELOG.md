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
