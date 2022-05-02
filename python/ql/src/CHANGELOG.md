## 0.1.0

## 0.0.13

## 0.0.12

## 0.0.11

### New Queries

* The query "XPath query built from user-controlled sources" (`py/xpath-injection`) has been promoted from experimental to the main query pack. Its results will now appear by default. This query was originally [submitted as an experimental query by @porcupineyhairs](https://github.com/github/codeql/pull/6331).

## 0.0.10

### New Queries

* The query "LDAP query built from user-controlled sources" (`py/ldap-injection`) has been promoted from experimental to the main query pack. Its results will now appear by default. This query was originally [submitted as an experimental query by @jorgectf](https://github.com/github/codeql/pull/5443).
* The query "Log Injection" (`py/log-injection`) has been promoted from experimental to the main query pack. Its results will now appear when `security-extended` is used. This query was originally [submitted as an experimental query by @haby0](https://github.com/github/codeql/pull/6182).

## 0.0.9

### Bug Fixes

* The [View AST functionality](https://codeql.github.com/docs/codeql-for-visual-studio-code/exploring-the-structure-of-your-source-code/) no longer prints detailed information about regular expressions, greatly improving performance.

## 0.0.8

### Major Analysis Improvements

* User names and other account information is no longer considered to be sensitive data for the queries `py/clear-text-logging-sensitive-data` and `py/clear-text-storage-sensitive-data`, since this lead to many false positives.

## 0.0.7

## 0.0.6

### New Queries

* Two new queries have been added for detecting Server-side request forgery (SSRF). _Full server-side request forgery_ (`py/full-ssrf`) will only alert when the URL is fully user-controlled, and _Partial server-side request forgery_ (`py/partial-ssrf`) will alert when any part of the URL is user-controlled. Only `py/full-ssrf` will be run by default.

### Minor Analysis Improvements

* To support the new SSRF queries, the PyPI package `requests` has been modeled, along with `http.client.HTTP[S]Connection` from the standard library.

## 0.0.5

### Minor Analysis Improvements

* Added modeling of many functions from the `os` module that uses file system paths, such as `os.stat`, `os.chdir`, `os.mkdir`, and so on. All of these are new sinks for the _Uncontrolled data used in path expression_ (`py/path-injection`) query.
* Added modeling of the `tempfile` module for creating temporary files and directories, such as the functions `tempfile.NamedTemporaryFile` and `tempfile.TemporaryDirectory`. The `suffix`, `prefix`, and `dir` arguments are all vulnerable to path-injection, and these are new sinks for the _Uncontrolled data used in path expression_ (`py/path-injection`) query.
* Extended the modeling of FastAPI such that `fastapi.responses.FileResponse` are considered `FileSystemAccess`, making them sinks for the _Uncontrolled data used in path expression_ (`py/path-injection`) query.
* Added modeling of the `posixpath`, `ntpath`, and `genericpath` modules for path operations (although these are not supposed to be used), resulting in new sinks for the _Uncontrolled data used in path expression_ (`py/path-injection`) query.
* Added modeling of `wsgiref.simple_server` applications, leading to new remote flow sources.

## 0.0.4

### Query Metadata Changes

* Fixed the query ids of two queries that are meant for manual exploration: `python/count-untrusted-data-external-api` and `python/untrusted-data-to-external-api` have been changed to `py/count-untrusted-data-external-api` and `py/untrusted-data-to-external-api`.
