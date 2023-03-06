## 0.8.0

### Breaking Changes

- Python 2 is no longer supported for extracting databases using the CodeQL CLI. As a consequence,
  the previously deprecated support for `pyxl` and `spitfire` templates has also been removed. When
  extracting Python 2 code, having Python 2 installed is still recommended, as this ensures the
  correct version of the Python standard library is extracted.

### Minor Analysis Improvements

* Fixed module resolution so we properly recognize that in `from <pkg> import *`, where `<pkg>` is a package, the actual imports are made from the `<pkg>/__init__.py` file.

## 0.7.2

No user-facing changes.

## 0.7.1

No user-facing changes.

## 0.7.0

### Major Analysis Improvements

* The _PAM authorization bypass due to incorrect usage_ (`py/pam-auth-bypass`) query has been converted to a taint-tracking query, resulting in significantly fewer false positives.

### Minor Analysis Improvements

* Added `subprocess.getoutput` and `subprocess.getoutputstatus` as new command injection sinks for the StdLib.
* The data-flow library has been rewritten to no longer rely on the points-to analysis in order to resolve references to modules. Improvements in the module resolution can lead to more results.
* Deleted the deprecated `importNode` predicate from the `DataFlowUtil.qll` file.
* Deleted the deprecated features from `PEP249.qll` that were not inside the `PEP249` module.
* Deleted the deprecated `werkzeug` from the `Werkzeug` module in `Werkzeug.qll`.
* Deleted the deprecated `methodResult` predicate from `PEP249::Cursor`.

### Bug Fixes

* `except*` is now supported.
* The result of `Try.getAHandler` and `Try.getHandler(<index>)` is no longer of type `ExceptStmt`, as handlers may also be `ExceptGroupStmt`s (After Python 3.11 introduced PEP 654). Instead, it is of the new type `ExceptionHandler` of which `ExceptStmt` and `ExceptGroupStmt` are subtypes. To support selecting only one type of handler, `Try.getANormalHandler` and `Try.getAGroupHandler` have been added. Existing uses of `Try.getAHandler` for which it is important to select only normal handlers, will need to be updated to `Try.getANormalHandler`.

## 0.6.6

No user-facing changes.

## 0.6.5

No user-facing changes.

## 0.6.4

### Minor Analysis Improvements

 * The ReDoS libraries in `semmle.code.python.security.regexp` have been moved to a shared pack inside the `shared/` folder, and the previous location has been deprecated.

## 0.6.3

No user-facing changes.

## 0.6.2

### Minor Analysis Improvements

* Fixed labels in the API graph pertaining to definitions of subscripts. Previously, these were found by `getMember` rather than `getASubscript`.
* Added edges for indices of subscripts to the API graph. Now a subscripted API node will have an edge to the API node for the index expression. So if `foo` is matched by API node `A`, then `"key"` in `foo["key"]` will be matched by the API node `A.getIndex()`. This can be used to track the origin of the index.
* Added member predicate `getSubscriptAt(API::Node index)` to `API::Node`. Like `getASubscript()`, this will return an API node that matches a subscript of the node, but here it will be restricted to subscripts where the index matches the `index` parameter.
* Added convenience predicate `getSubscript("key")` to obtain a subscript at a specific index, when the index happens to be a statically known string.

## 0.6.1

### Minor Analysis Improvements

* Added the ability to refer to subscript operations in the API graph. It is now possible to write `response().getMember("cookies").getASubscript()` to find code like `resp.cookies["key"]` (assuming `response` returns an API node for response objects).
* Added modeling of creating Flask responses with `flask.jsonify`.

## 0.6.0

### Deprecated APIs

* Some unused predicates in `SsaDefinitions.qll`, `TObject.qll`, `protocols.qll`, and the `pointsto/` folder have been deprecated.
* Some classes/modules with upper-case acronyms in their name have been renamed to follow our style-guide. 
  The old name still exists as a deprecated alias.

### Minor Analysis Improvements

* Changed `CallNode.getArgByName` such that it has results for keyword arguments given after a dictionary unpacking argument, as the `bar=2` argument in `func(foo=1, **kwargs, bar=2)`.
* `getStarArg` member-predicate on `Call` and `CallNode` has been changed for calls that have multiple `*args` arguments (for example `func(42, *my_args, *other_args)`): Instead of producing no results, it will always have a result for the _first_ such `*args` argument.
* Reads of global/non-local variables (without annotations) inside functions defined on classes now works properly in the case where the class had an attribute defined with the same name as the non-local variable.

### Bug Fixes

* Fixed an issue in the taint tracking analysis where implicit reads were not allowed by default in sinks or additional taint steps that used flow states.

## 0.5.5

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
