## 0.5.4

### Deprecated APIs

* Many classes/predicates/modules with upper-case acronyms in their name have been renamed to follow our style-guide. 
  The old name still exists as a deprecated alias.
* The utility files previously in the `semmle.python.security.performance` package have been moved to the `semmle.python.security.regexp` package.  
  The previous files still exist as deprecated aliases.

### Minor Analysis Improvements

* Most deprecated predicates/classes/modules that have been deprecated for over a year have been deleted.

## 0.5.3

### Minor Analysis Improvements

* Change `.getASubclass()` on `API::Node` so it allows to follow subclasses even if the class has a class decorator.

## 0.5.2

## 0.5.1

### Deprecated APIs

- The documentation of API graphs (the `API` module) has been expanded, and some of the members predicates of `API::Node`
  have been renamed as follows:
  - `getAnImmediateUse` -> `asSource`
  - `getARhs` -> `asSink`
  - `getAUse` -> `getAValueReachableFromSource`
  - `getAValueReachingRhs` -> `getAValueReachingSink`

### Minor Analysis Improvements

* Improved modeling of sensitive data sources, so common words like `certain` and `secretary` are no longer considered a certificate and a secret (respectively).

## 0.5.0

### Deprecated APIs

* The `BarrierGuard` class has been deprecated. Such barriers and sanitizers can now instead be created using the new `BarrierGuard` parameterized module.

## 0.4.1

## 0.4.0

### Breaking Changes

* `API::moduleImport` no longer has any results for dotted names, such as `API::moduleImport("foo.bar")`. Using `API::moduleImport("foo.bar").getMember("baz").getACall()` previously worked if the Python code was `from foo.bar import baz; baz()`, but not if the code was `import foo.bar; foo.bar.baz()` -- we are making this change to ensure the approach that can handle all cases is always used.

## 0.3.0

### Breaking Changes

* The imports made available from `import python` are no longer exposed under `DataFlow::` after doing `import semmle.python.dataflow.new.DataFlow`, for example using `DataFlow::Add` will now cause a compile error.

### Minor Analysis Improvements

* The modeling of `request.files` in Flask has been fixed, so we now properly handle assignments to local variables (such as `files = request.files; files['key'].filename`).
* Added taint propagation for `io.StringIO` and `io.BytesIO`. This addition was originally [submitted as part of an experimental query by @jorgectf](https://github.com/github/codeql/pull/6112).

## 0.2.0

### Breaking Changes

* The signature of `allowImplicitRead` on `DataFlow::Configuration` and `TaintTracking::Configuration` has changed from `allowImplicitRead(DataFlow::Node node, DataFlow::Content c)` to `allowImplicitRead(DataFlow::Node node, DataFlow::ContentSet c)`.

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
