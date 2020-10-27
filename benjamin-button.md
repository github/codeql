# benjamin-buttons.md

This file describes the changes that have been applied to
the library to make it behave as if it was younger.

## TaintedPath.ql

Sinks added between 2020-01-01 and 2020-10-06 have been removed. Found by looking at:

- the commit titles of https://github.com/github/codeql/commits/main/javascript/ql/test/query-tests/Security/CWE-022/TaintedPath/TaintedPath.expected
- the PR titles of https://github.com/github/codeql/pulls?page=2&q=is%3Apr+label%3AJS+is%3Aclosed+sink

Sinks added between 2018-08-02 and 2020-01-01 have been removed. Found by looking at:

- the commit titles of https://github.com/github/codeql/commits/main/javascript/ql/test/query-tests/Security/CWE-022/TaintedPath/TaintedPath.expected
- the PR titles of https://github.com/github/codeql/pulls?page=2&q=is%3Apr+label%3AJS+is%3Aclosed+sink
- the PR titles of https://github.com/github/codeql/pulls?page=2&q=is%3Apr+label%3AJS+is%3Aclosed+pathinjection
- the PR titles of https://github.com/github/codeql/pulls?page=2&q=is%3Apr+label%3AJS+is%3Aclosed+tainted-path

Sinks from the "graceful-fs" and "fs-extra" (added before the open-sourcing squash).

## Xss.ql

Sinks added between 2020-01-01 and 2020-10-06 have been removed. Found by looking at:

- the commit titles of https://github.com/github/codeql/commits/main/javascript/ql/test/query-tests/Security/CWE-079/Xss.expected
- the PR titles of https://github.com/github/codeql/pulls?page=2&q=is%3Apr+label%3AJS+is%3Aclosed+sink

- recursive type tracking for `jQuery::dollar`, `DOM::domValueRef`.

## SqlInjection.ql

Sinks added between 2020-01-01 and 2020-10-06 have been removed. Found by looking at:

- the commit titles of https://github.com/github/codeql/commits/main/javascript/ql/test/query-tests/Security/CWE-089
- the PR titles of https://github.com/github/codeql/pulls?page=2&q=is%3Apr+label%3AJS+is%3Aclosed+sink

Sinks added between 2018-08-02 and 2020-01-01 have been removed. Found by looking at:

- the commit titles of https://github.com/github/codeql/commits/main/javascript/ql/test/query-tests/Security/CWE-089
- the PR titles of https://github.com/github/codeql/pulls?page=2&q=is%3Apr+label%3AJS+is%3Aclosed+sink
- the PR titles of https://github.com/github/codeql/pulls?page=2&q=is%3Apr+label%3AJS+is%3Aclosed+sql

TypeTracking in SQL.qll (added before the open-sourcing squash)

The model of `mssql` and `sequelize` (added before the open-sourcing squash)

## PseudoProperties

Pseudo-properties (`$name$`) used in type-tracking and global dataflow configurations have been disabled.
Found by searching for `"\$.*\$"`.
