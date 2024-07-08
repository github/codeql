## 1.0.2

No user-facing changes.

## 1.0.1

No user-facing changes.

## 1.0.0

### Breaking Changes

* CodeQL package management is now generally available, and all GitHub-produced CodeQL packages have had their version numbers increased to 1.0.0.

### New Features

* A Python MaD (Models as Data) row may now contain a dotted path in the `type` column. Like in Ruby, a path to a class will refer to instances of that class. This means that the summary `["foo", "Member[MyClass].Instance.Member[instance_method]", "Argument[0]", "ReturnValue", "value"]` can now be written `["foo.MS_Class", "Member[instance_method]", "Argument[0]", "ReturnValue", "value"]`. To refer to an actual class, one may add a `!` at the end of the path.

### Minor Analysis Improvements

* The `request` parameter of Flask `SessionInterface.open_session` method is now modeled as a remote flow source.
* Additional heuristics for a new sensitive data classification for private information (e.g. credit card numbers) have been added to the shared `SensitiveDataHeuristics.qll` library. This may result in additional results for queries that use sensitive data such as `py/clear-text-storage-sensitive-data` and `py/clear-text-logging-sensitive-data`.

## 0.12.1

### Major Analysis Improvements

* Added modeling of the `pyramid` framework, leading to new remote flow sources and sinks.

## 0.12.0

### Breaking Changes

* Deleted the deprecated `RegExpPatterns` module from `Regexp.qll`.
* Deleted the deprecated `Security/CWE-020/HostnameRegexpShared.qll` file.

### Deprecated APIs

- Renamed the `StrConst` class to `StringLiteral`, for greater consistency with other languages. The `StrConst` and `Str` classes are now deprecated and will be removed in a future release.

## 0.11.14

### Minor Analysis Improvements

* Improved the type-tracking capabilities (and therefore also API graphs) to allow tracking items in tuples and dictionaries.

## 0.11.13

No user-facing changes.

## 0.11.12

No user-facing changes.

## 0.11.11

No user-facing changes.

## 0.11.10

### Minor Analysis Improvements

* Fixed missing flow for dictionary updates (`d[<key>] = ...`) when `<key>` is a string constant not used in dictionary literals or as name of keyword-argument.
* Fixed flow for iterable unpacking (`a,b = my_tuple`) when it occurs on top-level (module) scope.

## 0.11.9

### Minor Analysis Improvements

* The name "certification" is no longer seen as possibly being a certificate, and will therefore no longer be flagged in queries like "clear-text-logging" which look for sensitive data.
* Added modeling of the `psycopg` PyPI package as a SQL database library.

## 0.11.8

### Minor Analysis Improvements

* Added `html.escape` as a sanitizer for HTML.

### Bug Fixes

* Fixed the `a` (ASCII) inline flag not being recognized by the regular expression library.

## 0.11.7

### Minor Analysis Improvements

* Deleted many deprecated predicates and classes with uppercase `LDAP`, `HTTP`, `URL`, `CGI` etc. in their names. Use the PascalCased versions instead.
* Deleted the deprecated `localSourceStoreStep` predicate, use `flowsToStoreStep` instead.
* Deleted the deprecated `iteration_defined_variable` predicate from the `SSA` library.
* Deleted various deprecated predicates from the points-to libraries.
* Deleted the deprecated `semmle/python/security/OverlyLargeRangeQuery.qll`, `semmle/python/security/regexp/ExponentialBackTracking.qll`, `semmle/python/security/regexp/NfaUtils.qll`, and `semmle/python/security/regexp/NfaUtils.qll` files.
* The diagnostic query `py/diagnostics/successfully-extracted-files`, and therefore the Code Scanning UI measure of scanned Python files, now considers any Python file seen during extraction, even one with some errors, to be extracted / scanned.

## 0.11.6

### Major Analysis Improvements

* Added support for global data-flow through captured variables.

### Minor Analysis Improvements

* Captured subclass relationships ahead-of-time for most popular PyPI packages so we are able to resolve subclass relationships even without having the packages installed. For example we have captured that `flask_restful.Resource` is a subclass of `flask.views.MethodView`, so our Flask modeling will still consider a function named `post` on a `class Foo(flask_restful.Resource):` as a HTTP request handler.
* Python now makes use of the shared type tracking library, exposed as `semmle.python.dataflow.new.TypeTracking`. The existing type tracking library, `semmle.python.dataflow.new.TypeTracker`, has consequently been deprecated.

### Bug Fixes

- We would previously confuse all captured variables into a single scope entry node. Now they each get their own node so they can be tracked properly.
- The dataflow graph no longer contains SSA variables. Instead, flow is directed via the corresponding controlflow nodes. This should make the graph and the flow simpler to understand. Minor improvements in flow computation has been observed, but in general negligible changes to alerts are expected.

## 0.11.5

No user-facing changes.

## 0.11.4

### Minor Analysis Improvements

- Added support for tarfile extraction filters as defined in [PEP-706](https://peps.python.org/pep-0706). In particular, calls to `TarFile.extract`, and `TarFile.extractall` are no longer considered to be sinks for the `py/tarslip` query if a sufficiently safe filter is provided.
* Added modeling of `*args` and `**kwargs` as routed-parameters in request handlers for django/flask/FastAPI/tornado.
- Added support for type parameters in function and class definitions, as well as the new Python 3.12 type alias statement.
* Added taint-flow modeling for regular expressions with `re` module from the standard library.

## 0.11.3

### Minor Analysis Improvements

* Added basic flow for attributes defined on classes, when the attribute lookup is on a direct reference to that class (so not instance, cls parameter, or self parameter). Example: class definition `class Foo: my_tuples = (dangerous, safe)` and usage `SINK(Foo.my_tuples[0])`.

## 0.11.2

### Minor Analysis Improvements

* Added support for functions decorated with `contextlib.contextmanager`.
* Namespace packages in the form of regular packages with missing `__init__.py`-files are now allowed. This enables the analysis to resolve modules and functions inside such packages.

## 0.11.1

### Minor Analysis Improvements

* Added better support for API graphs when encountering `from ... import *`. For example in the code `from foo import *; Bar()`, we will now find a result for `API::moduleImport("foo").getMember("Bar").getACall()`
* Deleted the deprecated `isBarrierGuard` predicate from the dataflow library and its uses, use `isBarrier` and the `BarrierGuard` module instead.
* Deleted the deprecated `getAUse`, `getAnImmediateUse`, `getARhs`, and `getAValueReachingRhs` predicates from the `API::Node` class.
* Deleted the deprecated `fullyQualifiedToAPIGraphPath` class from `SubclassFinder.qll`, use `fullyQualifiedToApiGraphPath` instead.
* Deleted the deprecated `Paths.qll` file.
* Deleted the deprecated `semmle.python.security.performance` folder, use `semmle.python.security.regexp` instead.
* Deleted the deprecated `semmle.python.security.strings` and `semmle.python.web` folders.
* Improved modeling of decoding through pickle related functions (which can lead to code execution), resulting in additional sinks for the _Deserializing untrusted input_ query (`py/unsafe-deserialization`). Added support for `pandas.read_pickle`, `numpy.load` and `joblib.load`.

## 0.11.0

### Minor Analysis Improvements

* Django Rest Framework better handles custom `ModelViewSet` classes functions
* Regular expression fragments residing inside implicitly concatenated strings now have better location information.

### Bug Fixes

* Subterms of regular expressions encoded as single-line string literals now have better source-location information.

## 0.10.5

No user-facing changes.

## 0.10.4

### Minor Analysis Improvements

* Regular expressions containing multiple parse mode flags are now interpretted correctly. For example `"(?is)abc.*"` with both the `i` and `s` flags.
* Added `shlex.quote` as a sanitizer for the `py/shell-command-constructed-from-input` query.

## 0.10.3

### Minor Analysis Improvements

* Support analyzing packages (folders with python code) that do not have `__init__.py` files, although this is technically required, we see real world projects that don't have this.
* Added modeling of AWS Lambda handlers that can be identified with `AWS::Serverless::Function` in YAML files, where the event parameter is modeled as a remote-flow-source.
* Improvements of the `aiohttp` models including remote-flow-sources from type annotations, new path manipulation, and SSRF sinks.

### Bug Fixes

* Fixed the computation of locations for imports with aliases in jump-to-definition.

## 0.10.2

No user-facing changes.

## 0.10.1

### New Features

* The `DataFlow::StateConfigSig` signature module has gained default implementations for `isBarrier/2` and `isAdditionalFlowStep/4`. 
  Hence it is no longer needed to provide `none()` implementations of these predicates if they are not needed.

### Minor Analysis Improvements

* Data flow configurations can now include a predicate `neverSkip(Node node)`
  in order to ensure inclusion of certain nodes in the path explanations. The
  predicate defaults to the end-points of the additional flow steps provided in
  the configuration, which means that such steps now always are visible by
  default in path explanations.
* Add support for Models as Data for Reflected XSS query
* Parameters with a default value are now considered a `DefinitionNode`. This improvement was motivated by allowing type-tracking and API graphs to follow flow from such a default value to a use by a captured variable.

## 0.10.0

### New Features

* It is now possible to specify flow summaries in the format "MyPkg;Member[list_map];Argument[1].ListElement;Argument[0].Parameter[0];value"

### Minor Analysis Improvements

* Deleted many models that used the old dataflow library, the new models can be found in the `python/ql/lib/semmle/python/frameworks` folder.
* More precise modeling of several container functions (such as `sorted`, `reversed`) and methods (such as `set.add`, `list.append`).
* Added modeling of taint flow through the template argument of `flask.render_template_string` and `flask.stream_template_string`.
* Deleted many deprecated predicates and classes with uppercase `API`, `HTTP`, `XSS`, `SQL`, etc. in their names. Use the PascalCased versions instead.
* Deleted the deprecated `getName()` predicate from the `Container` class, use `getAbsolutePath()` instead.
* Deleted many deprecated module names that started with a lowercase letter, use the versions that start with an uppercase letter instead.
* Deleted many deprecated predicates in `PointsTo.qll`. 
* Deleted many deprecated files from the `semmle.python.security` package.
* Deleted the deprecated `BottleRoutePointToExtension` class from `Extensions.qll`.
* Type tracking is now aware of flow summaries. This leads to a richer API graph, and may lead to more results in some queries.

## 0.9.4

No user-facing changes.

## 0.9.3

No user-facing changes.

## 0.9.2

### Minor Analysis Improvements

* Type tracking is now aware of reads of captured variables (variables defined in an outer scope). This leads to a richer API graph, and may lead to more results in some queries.
* Added more content-flow/field-flow for dictionaries, by adding support for reads through `mydict.get("key")` and `mydict.setdefault("key", value)`, and store steps through `dict["key"] = value` and `mydict.setdefault("key", value)`.

## 0.9.1

### Minor Analysis Improvements

* Added support for querying the contents of YAML files.

## 0.9.0

### Deprecated APIs

* The recently introduced new data flow and taint tracking APIs have had a
  number of module and predicate renamings. The old APIs remain in place for
  now.

### Minor Analysis Improvements

* Added modeling of SQL execution in the packages `sqlite3.dbapi2`, `cassandra-driver`, `aiosqlite`, and the functions `sqlite3.Connection.executescript`/`sqlite3.Cursor.executescript` and `asyncpg.connection.connect()`.
* Fixed module resolution so we allow imports of definitions that have had an attribute assigned to it, such as `class Foo; Foo.bar = 42`.

### Bug Fixes

* Fixed some accidental predicate visibility in the backwards-compatible wrapper for data flow configurations. In particular, `DataFlow::hasFlowPath`, `DataFlow::hasFlow`, `DataFlow::hasFlowTo`, and `DataFlow::hasFlowToExpr` were accidentally exposed in a single version.

## 0.8.3

No user-facing changes.

## 0.8.2

### New Features

* Added support for merging two `PathGraph`s via disjoint union to allow results from multiple data flow computations in a single `path-problem` query.

### Major Analysis Improvements

* The main data flow and taint tracking APIs have been changed. The old APIs
  remain in place for now and translate to the new through a
  backwards-compatible wrapper. If multiple configurations are in scope
  simultaneously, then this may affect results slightly. The new API is quite
  similar to the old, but makes use of a configuration module instead of a
  configuration class.

### Minor Analysis Improvements

* Deleted the deprecated `getPath` and `getFolder` predicates from the `XmlFile` class.

## 0.8.1

### Major Analysis Improvements

* We use a new analysis for the call-graph (determining which function is called). This can lead to changed results. In most cases this is much more accurate than the old call-graph that was based on points-to, but we do lose a few valid edges in the call-graph, especially around methods that are not defined inside its class.

### Minor Analysis Improvements

* Fixed module resolution so we properly recognize definitions made within if-then-else statements.
* Added modeling of cryptographic operations in the `hmac` library.

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
