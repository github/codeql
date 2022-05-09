## 0.1.0

### Breaking Changes

* The recently added flow-state versions of `isBarrierIn`, `isBarrierOut`, `isSanitizerIn`, and `isSanitizerOut` in the data flow and taint tracking libraries have been removed.

### Deprecated APIs

* Queries importing a data-flow configuration from `semmle.python.security.dataflow`
  should ensure that the imported file ends with `Query`, and only import its top-level
  module. For example, a query that used `CommandInjection::Configuration` from
  `semmle.python.security.dataflow.CommandInjection` should from now use `Configuration`
  from `semmle.python.security.dataflow.CommandInjectionQuery` instead.

### Major Analysis Improvements

* Added data-flow for Django ORM models that are saved in a database (no `models.ForeignKey` support).

### Minor Analysis Improvements

* Improved modeling of Flask `Response` objects, so passing a response body with the keyword argument `response` is now recognized.

## 0.0.13

## 0.0.12

### Breaking Changes

* The flow state variants of `isBarrier` and `isAdditionalFlowStep` are no longer exposed in the taint tracking library. The `isSanitizer` and `isAdditionalTaintStep` predicates should be used instead.

### Deprecated APIs

* Many classes/predicates/modules that had upper-case acronyms have been renamed to follow our style-guide. 
  The old name still exists as a deprecated alias.
* Some modules that started with a lowercase letter have been renamed to follow our style-guide. 
  The old name still exists as a deprecated alias.

### New Features

* The data flow and taint tracking libraries have been extended with versions of `isBarrierIn`, `isBarrierOut`, and `isBarrierGuard`, respectively `isSanitizerIn`, `isSanitizerOut`, and `isSanitizerGuard`, that support flow states.

### Minor Analysis Improvements

* All deprecated predicates/classes/modules that have been deprecated for over a year have been deleted.

## 0.0.11

### Minor Analysis Improvements

* Added new SSRF sinks for `httpx`, `pycurl`, `urllib`, `urllib2`, `urllib3`, and `libtaxii`. This improvement was [submitted by @haby0](https://github.com/github/codeql/pull/8275).
* The regular expression parser now groups sequences of normal characters. This reduces the number of instances of `RegExpNormalChar`.
* Fixed taint propagation for attribute assignment. In the assignment `x.foo = tainted` we no longer treat the entire object `x` as tainted, just because the attribute `foo` contains tainted data. This leads to slightly fewer false positives.
* Improved analysis of attributes for data-flow and taint tracking queries, so `getattr`/`setattr` are supported, and a write to an attribute properly stops flow for the old value in that attribute.
* Added post-update nodes (`DataFlow::PostUpdateNode`) for arguments in calls that can't be resolved.

## 0.0.10

### Deprecated APIs

* The old points-to based modeling has been deprecated. Use the new type-tracking/API-graphs based modeling instead.

## 0.0.9

## 0.0.8

### Deprecated APIs

* Moved the files defining regex injection configuration and customization, instead of `import semmle.python.security.injection.RegexInjection` please use `import semmle.python.security.dataflow.RegexInjection` (the same for `RegexInjectionCustomizations`).
* The `codeql/python-upgrades` CodeQL pack has been removed. All upgrades scripts have been merged into the `codeql/python-all` CodeQL pack.

## 0.0.7

## 0.0.6

## 0.0.5

### Minor Analysis Improvements

* Added modeling of many functions from the `os` module that uses file system paths, such as `os.stat`, `os.chdir`, `os.mkdir`, and so on.
* Added modeling of the `tempfile` module for creating temporary files and directories, such as the functions `tempfile.NamedTemporaryFile` and `tempfile.TemporaryDirectory`.
* Extended the modeling of FastAPI such that custom subclasses of `fastapi.APIRouter` are recognized.
* Extended the modeling of FastAPI such that `fastapi.responses.FileResponse` are considered `FileSystemAccess`.
* Added modeling of the `posixpath`, `ntpath`, and `genericpath` modules for path operations (although these are not supposed to be used), resulting in new sinks.
* Added modeling of `wsgiref.simple_server` applications, leading to new remote flow sources.

## 0.0.4

### Major Analysis Improvements

* Added modeling of `os.stat`, `os.lstat`, `os.statvfs`, `os.fstat`, and `os.fstatvfs`, which are new sinks for the _Uncontrolled data used in path expression_ (`py/path-injection`) query.
* Added modeling of the `posixpath`, `ntpath`, and `genericpath` modules for path operations (although these are not supposed to be used), resulting in new sinks for the _Uncontrolled data used in path expression_ (`py/path-injection`) query.
* Added modeling of `wsgiref.simple_server` applications, leading to new remote flow sources.
* Added modeling of `aiopg` for sinks executing SQL.
* Added modeling of HTTP requests and responses when using `flask_admin` (`Flask-Admin` PyPI package), which leads to additional remote flow sources.
* Added modeling of the PyPI package `toml`, which provides encoding/decoding of TOML documents, leading to new taint-tracking steps.
