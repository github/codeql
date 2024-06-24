## 1.0.2

No user-facing changes.

## 1.0.1

No user-facing changes.

## 1.0.0

### Breaking Changes

* CodeQL package management is now generally available, and all GitHub-produced CodeQL packages have had their version numbers increased to 1.0.0.

### Minor Analysis Improvements

* Additional heuristics for a new sensitive data classification for private information (e.g. credit card numbers) have been added to the shared `SensitiveDataHeuristics.qll` library. This may result in additional results for queries that use sensitive data such as `rb/sensitive-get-query`.

## 0.9.1

No user-facing changes.

## 0.9.0

### Breaking Changes

* Deleted the deprecated `RegExpPatterns` module from `Regexp.qll`.
* Deleted the deprecated `security/cwe-020/HostnameRegexpShared.qll` file.

## 0.8.14

No user-facing changes.

## 0.8.13

### Minor Analysis Improvements

* Data flow is now tracked through `ActiveRecord` scopes.
* Modeled instances of `ActionDispatch::Http::UploadedFile` that can be obtained from element reads of `ActionController::Parameters`, with calls to `original_filename`, `content_type`, and `read` now propagating taint from their receiver. 
* The second argument, `subquery_name`, of the `ActiveRecord::QueryMethods::from` method, is now recognized as an sql injection sink.
* Calls to `Typhoeus::Request.new` are now considered as instances of the `Http::Client::Request` concept, with the response body being treated as a remote flow source.
* New command injection sinks have been added, including `Process.spawn`, `Process.exec`, `Terrapin::CommandLine` and the `open4` gem.

## 0.8.12

No user-facing changes.

## 0.8.11

No user-facing changes.

## 0.8.10

### Minor Analysis Improvements

* Calls to `I18n.translate` as well as Rails helper translate methods now propagate taint from their keyword arguments. The Rails translate methods are also recognized as XSS sanitizers when using keys marked as html safe.
* Calls to `Arel::Nodes::SqlLiteral.new` are now modeled as instances of the `SqlConstruction` concept, as well as propagating taint from their argument.
* Additional arguments beyond the first of calls to the  `ActiveRecord` methods `select`, `reselect`, `order`, `reorder`, `joins`, `group`, and `pluck` are now recognized as sql injection sinks. 
* Calls to several methods of `ActiveRecord::Connection`, such as `ActiveRecord::Connection#exec_query`, are now recognized as SQL executions, including those via subclasses.

## 0.8.9

### Minor Analysis Improvements

* Raw output ERB tags of the form `<%== ... %>` are now recognised as cross-site scripting sinks.
* The name "certification" is no longer seen as possibly being a certificate, and will therefore no longer be flagged in queries like "clear-text-logging" which look for sensitive data.

## 0.8.8

### Minor Analysis Improvements

* Flow is now tracked through Rails `render` calls, when the argument is a `ViewComponent`. In this case, data flow is tracked into the accompanying `.html.erb` file.

## 0.8.7

### Minor Analysis Improvements

* Deleted many deprecated predicates and classes with uppercase `HTTP`, `CSRF` etc. in their names. Use the PascalCased versions instead.
* Deleted the deprecated `getAUse` and `getARhs` predicates from `API::Node`, use `getASource` and `getASink` instead.
* Deleted the deprecated `disablesCertificateValidation` predicate from the `Http` module.
* Deleted the deprecated `ParamsCall`, `CookiesCall`, and `ActionControllerControllerClass` classes from `ActionController.qll`, use the simarly named classes from `codeql.ruby.frameworks.Rails::Rails` instead.
* Deleted the deprecated `HtmlSafeCall`, `HtmlEscapeCall`, `RenderCall`, and `RenderToCall` classes from `ActionView.qll`, use the simarly named classes from `codeql.ruby.frameworks.Rails::Rails` instead.
* Deleted the deprecated `HtmlSafeCall` class from `Rails.qll`.
* Deleted the deprecated `codeql/ruby/security/BadTagFilterQuery.qll`, `codeql/ruby/security/OverlyLargeRangeQuery.qll`, `codeql/ruby/security/regexp/ExponentialBackTracking.qll`, `codeql/ruby/security/regexp/NfaUtils.qll`, `codeql/ruby/security/regexp/RegexpMatching.qll`, and `codeql/ruby/security/regexp/SuperlinearBackTracking.qll` files.
* Deleted the deprecated `localSourceStoreStep` predicate from `TypeTracker.qll`, use `flowsToStoreStep` instead.
* The diagnostic query `rb/diagnostics/successfully-extracted-files`, and therefore the Code Scanning UI measure of scanned Ruby files, now considers any Ruby file seen during extraction, even one with some errors, to be extracted / scanned.

## 0.8.6

### Minor Analysis Improvements

* Parsing of division operators (`/`) at the end of a line has been improved. Before they were wrongly interpreted as the start of a regular expression literal (`/.../`) leading to syntax errors.
* Parsing of `case` statements that are formatted with the value expression on a different line than the `case` keyword  has been improved and should no longer lead to syntax errors.
* Ruby now makes use of the shared type tracking library, exposed as `codeql.ruby.typetracking.TypeTracking`. The existing type tracking library, `codeql.ruby.typetracking.TypeTracker`, has consequently been deprecated.

## 0.8.5

No user-facing changes.

## 0.8.4

### Minor Analysis Improvements

* Improved modeling for `ActiveRecord`s `update_all` method

## 0.8.3

No user-facing changes.

## 0.8.2

No user-facing changes.

## 0.8.1

### Minor Analysis Improvements

* Deleted the deprecated `isBarrierGuard` predicate from the dataflow library and its uses, use `isBarrier` and the `BarrierGuard` module instead.
* Deleted the deprecated `isWeak` predicate from the `CryptographicOperation` class.
* Deleted the deprecated `getStringOrSymbol` and `isStringOrSymbol` predicates from the `ConstantValue` class.
* Deleted the deprecated `getAPI` from the `IOOrFileMethodCall` class.
* Deleted the deprecated `codeql.ruby.security.performance` folder, use `codeql.ruby.security.regexp` instead.
* GraphQL enums are no longer considered remote flow sources.

## 0.8.0

### Major Analysis Improvements

* Improved support for flow through captured variables that properly adheres to inter-procedural control flow.

## 0.7.5

No user-facing changes.

## 0.7.4

No user-facing changes.

## 0.7.3

### Minor Analysis Improvements

* Flow between positional arguments and splat parameters (`*args`) is now tracked more precisely.
* Flow between splat arguments (`*args`) and positional parameters is now tracked more precisely.

## 0.7.2

No user-facing changes.

## 0.7.1

### New Features

* The `DataFlow::StateConfigSig` signature module has gained default implementations for `isBarrier/2` and `isAdditionalFlowStep/4`. 
  Hence it is no longer needed to provide `none()` implementations of these predicates if they are not needed.

### Major Analysis Improvements

* The API graph library (`codeql.ruby.ApiGraphs`) has been significantly improved, with better support for inheritance,
  and data-flow nodes can now be converted to API nodes by calling `.track()` or `.backtrack()` on the node.
  API graphs allow for efficient modelling of how a given value is used by the code base, or how values produced by the code base
  are consumed by a library. See the documentation for `API::Node` for details and examples.

### Minor Analysis Improvements

* Data flow configurations can now include a predicate `neverSkip(Node node)`
  in order to ensure inclusion of certain nodes in the path explanations. The
  predicate defaults to the end-points of the additional flow steps provided in
  the configuration, which means that such steps now always are visible by
  default in path explanations.
* The `'QUERY_STRING'` field of a Rack `env` parameter is now recognized as a source of remote user input.
* Query parameters and cookies from `Rack::Response` objects are recognized as potential sources of remote flow input.
* Calls to `Rack::Utils.parse_query` now propagate taint.

## 0.7.0

### Deprecated APIs

* The `Configuration` taint flow configuration class from `codeql.ruby.security.InsecureDownloadQuery` has been deprecated. Use the `Flow` module instead.

### Minor Analysis Improvements

* More kinds of rack applications are now recognized.
* Rack::Response instances are now recognized as potential responses from rack applications.
* HTTP redirect responses from Rack applications are now recognized as a potential sink for open redirect alerts.
* Additional sinks for `rb/unsafe-deserialization` have been added. This includes various methods from the `yaml` and `plist` gems, which deserialize YAML and Property List data, respectively.

## 0.6.4

No user-facing changes.

## 0.6.3

### Minor Analysis Improvements

* Deleted many deprecated predicates and classes with uppercase `URL`, `XSS`, etc. in their names. Use the PascalCased versions instead.
* Deleted the deprecated `getValueText` predicate from the `Expr`, `StringComponent`, and `ExprCfgNode` classes. Use `getConstantValue` instead.
* Deleted the deprecated `VariableReferencePattern` class, use `ReferencePattern` instead.
* Deleted all deprecated aliases in `StandardLibrary.qll`, use `codeql.ruby.frameworks.Core` and `codeql.ruby.frameworks.Stdlib` instead.
* Support for the `sequel` gem has been added. Method calls that execute queries against a database that may be vulnerable to injection attacks will now be recognized.
* Support for the `mysql2` gem has been added. Method calls that execute queries against an MySQL database that may be vulnerable to injection attacks will now be recognized.
* Support for the `pg` gem has been added. Method calls that execute queries against a PostgreSQL database that may be vulnerable to injection attacks will now be recognized.

## 0.6.2

### Minor Analysis Improvements

* Support for the `sqlite3` gem has been added. Method calls that execute queries against an SQLite3 database that may be vulnerable to injection attacks will now be recognized.

## 0.6.1

No user-facing changes.

## 0.6.0

### Deprecated APIs

* The recently introduced new data flow and taint tracking APIs have had a
  number of module and predicate renamings. The old APIs remain in place for
  now.

### Minor Analysis Improvements

* Control flow graph: the evaluation order of scope expressions and receivers in multiple assignments has been adjusted to match the changes made in Ruby 
3.1 and 3.2.
* The clear-text storage (`rb/clear-text-storage-sensitive-data`) and logging (`rb/clear-text-logging-sensitive-data`) queries now use built-in flow through hashes, for improved precision. This may result in both new true positives and less false positives.
* Accesses of `params` in Sinatra applications are now recognized as HTTP input accesses.
* Data flow is tracked from Sinatra route handlers to ERB files.
* Data flow is tracked between basic Sinatra filters (those without URL patterns) and their corresponding route handlers.

### Bug Fixes

* Fixed some accidental predicate visibility in the backwards-compatible wrapper for data flow configurations. In particular `DataFlow::hasFlowPath`, `DataFlow::hasFlow`, `DataFlow::hasFlowTo`, and `DataFlow::hasFlowToExpr` were accidentally exposed in a single version.

## 0.5.6

No user-facing changes.

## 0.5.5

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

* Data flow through `initialize` methods is now taken into account also when the receiver of a `new` call is an (implicit or explicit) `self`.
* The Active Record query methods `reorder` and `count_by_sql` are now recognized as SQL executions.
* Calls to `ActiveRecord::Connection#execute`, including those via subclasses, are now recognized as SQL executions.
* Data flow through `ActionController::Parameters#require` is now tracked properly.
* The severity of parse errors was reduced to warning (previously error). 
* Deleted the deprecated `getQualifiedName` predicate from the `ConstantWriteAccess` class.
* Deleted the deprecated `getWhenBranch` and `getAWhenBranch` predicates from the `CaseExpr` class.
* Deleted the deprecated `Self`, `PatternParameter`, `Pattern`, `VariablePattern`, `TuplePattern`, and `TuplePatternParameter` classes.

## 0.5.4

### Minor Analysis Improvements

* Flow is now tracked between ActionController `before_filter` and `after_filter` callbacks and their associated action methods.
* Calls to `ApplicationController#render` and `ApplicationController::Renderer#render` are recognized as Rails rendering calls.
* Support for [Twirp framework](https://twitchtv.github.io/twirp/docs/intro.html).

## 0.5.3

### Minor Analysis Improvements

 * Ruby 3.1: one-line pattern matches are now supported. The AST nodes are named `TestPattern` (`expr in pattern`) and `MatchPattern` (`expr => pattern`).

## 0.5.2

### Minor Analysis Improvements

* Data flowing from the `locals` argument of a Rails `render` call is now tracked to uses of that data in an associated view.
* Access to headers stored in the `env` of Rack requests is now recognized as a source of remote input.
* Ruby 3.2: anonymous rest and keyword rest arguments can now be passed as arguments, instead of just used in method parameters.

## 0.5.1

No user-facing changes.

## 0.5.0

### Major Analysis Improvements

* Flow through `initialize` constructors is now taken into account. For example, in
  ```rb
  class C
    def initialize(x)
      @field = x
    end
  end

  C.new(y)
  ```
  there will be flow from `y` to the field `@field` on the constructed `C` object.

### Minor Analysis Improvements

* Calls to `Kernel.load`, `Kernel.require`, `Kernel.autoload` are now modeled as sinks for path injection.
* Calls to `mail` and `inbound_mail` in `ActionMailbox` controllers are now considered sources of remote input.
* Calls to `GlobalID::Locator.locate` and its variants are now recognized as instances of `OrmInstantiation`.
* Data flow through the `ActiveSupport` extensions `Enumerable#index_with`, `Enumerable#pick`, `Enumerable#pluck` and `Enumerable#sole`  are now modeled.
* When resolving a method call, the analysis now also searches in sub-classes of the receiver's type.
* Taint flow is now tracked through many common JSON parsing and generation methods.
* The ReDoS libraries in `codeql.ruby.security.regexp` has been moved to a shared pack inside the `shared/` folder, and the previous location has been deprecated.
* String literals and arrays of string literals in case expression patterns are now recognised as barrier guards.

## 0.4.6

No user-facing changes.

## 0.4.5

No user-facing changes.

## 0.4.4

### Minor Analysis Improvements

* Data flow through the `ActiveSupport` extension `Enumerable#index_by` is now modeled.
* The `codeql.ruby.Concepts` library now has a `SqlConstruction` class, in addition to the existing `SqlExecution` class.
* Calls to `Arel.sql` are now modeled as instances of the new `SqlConstruction` concept.
* Arguments to RPC endpoints (public methods) on subclasses of `ActionCable::Channel::Base` are now recognized as sources of remote user input.
* Taint flow through the `ActiveSupport` extensions `Hash#reverse_merge` and `Hash:reverse_merge!`, and their aliases, is now modeled more generally, where previously it was only modeled in the context of `ActionController` parameters.
* Calls to `logger` in `ActiveSupport` actions are now recognised as logger instances.
* Calls to `send_data` in `ActiveSupport` actions are recognised as HTTP responses.
* Calls to `body_stream` in `ActiveSupport` actions are recognised as HTTP request accesses.
* The `ActiveSupport` extensions `Object#try` and `Object#try!` are now recognised as code executions.

## 0.4.3

### Minor Analysis Improvements

* There was a bug in `TaintTracking::localTaint` and `TaintTracking::localTaintStep` such that they only tracked non-value-preserving flow steps. They have been fixed and now also include value-preserving steps.
* Instantiations using `Faraday::Connection.new` are now recognized as part of `FaradayHttpRequest`s, meaning they will be considered as sinks for queries such as `rb/request-forgery`.
* Taint flow is now tracked through extension methods on `Hash`, `String` and
  `Object` provided by `ActiveSupport`.

## 0.4.2

### Minor Analysis Improvements

* The hashing algorithms from `Digest` and `OpenSSL::Digest` are now recognized and can be flagged by the `rb/weak-cryptographic-algorithm` query.
* More sources of remote input arising from methods on `ActionDispatch::Request` are now recognized.
* The response value returned by the `Faraday#run_request` method is now also considered a source of remote input.
* `ActiveJob::Serializers.deserialize` is considered to be a code execution sink.
* Calls to `params` in `ActionMailer` classes are now treated as sources of remote user input.
* Taint flow through `ActionController::Parameters` is tracked more accurately.

## 0.4.1

### Minor Analysis Improvements

* The following classes have been moved from `codeql.ruby.frameworks.ActionController` to `codeql.ruby.frameworks.Rails`:
    * `ParamsCall`, now accessed as `Rails::ParamsCall`.
    * `CookieCall`, now accessed as `Rails::CookieCall`.
* The following classes have been moved from `codeql.ruby.frameworks.ActionView` to `codeql.ruby.frameworks.Rails`:
    * `HtmlSafeCall`, now accessed as `Rails::HtmlSafeCall`.
    * `HtmlEscapeCall`, now accessed as `Rails::HtmlEscapeCall`.
    * `RenderCall`, now accessed as `Rails::RenderCall`.
    * `RenderToCall`, now accessed as `Rails::RenderToCall`.
* Subclasses of `ActionController::Metal` are now recognised as controllers.
* `ActionController::DataStreaming::send_file` is now recognized as a
  `FileSystemAccess`.
* Various XSS sinks in the ActionView library are now recognized.
* Calls to `ActiveRecord::Base.create` are now recognized as model
  instantiations.
* Various code executions, command executions and HTTP requests in the
  ActiveStorage library are now recognized.
* `MethodBase` now has two new predicates related to visibility: `isPublic` and
  `isProtected`. These hold, respectively, if the method is public or protected.

## 0.4.0

### Breaking Changes

* `import ruby` no longer brings the standard Ruby AST library into scope; it instead brings a module `Ast` into scope, which must be imported. Alternatively, it is also possible to import `codeql.ruby.AST`.
* Changed the `HTTP::Client::Request` concept from using `MethodCall` as base class, to using `DataFlow::Node` as base class. Any class that extends `HTTP::Client::Request::Range` must be changed, but if you only use the member predicates of `HTTP::Client::Request`, no changes are required.

### Deprecated APIs

* Some classes/modules with upper-case acronyms in their name have been renamed to follow our style-guide. 
  The old name still exists as a deprecated alias.

### Minor Analysis Improvements

* Uses of `ActionView::FileSystemResolver` are now recognized as filesystem accesses.
* Accesses of ActiveResource models are now recognized as HTTP requests.

### Bug Fixes

* Fixed an issue in the taint tracking analysis where implicit reads were not allowed by default in sinks or additional taint steps that used flow states.

## 0.3.5

## 0.3.4

### Deprecated APIs

* The utility files previously in the `codeql.ruby.security.performance` package have been moved to the `codeql.ruby.security.regexp` package.  
  The previous files still exist as deprecated aliases.

### Minor Analysis Improvements

* Most deprecated predicates/classes/modules that have been deprecated for over a year have been deleted.
* Calls to `render` in Rails controllers and views are now recognized as HTTP
  response bodies.

## 0.3.3

### Minor Analysis Improvements

* Calls to methods generated by ActiveRecord associations are now recognised as
  instantiations of ActiveRecord objects. This increases the sensitivity of
  queries such as `rb/sql-injection` and `rb/stored-xss`.
* Calls to `ActiveRecord::Base.create` and `ActiveRecord::Base.update` are now
  recognised as write accesses.
* Arguments to `Mime::Type#match?` and `Mime::Type#=~` are now recognised as
  regular expression sources.

## 0.3.2

### Minor Analysis Improvements

* Calls to `Arel.sql` are now recognised as propagating taint from their argument.
* Calls to `ActiveRecord::Relation#annotate` are now recognized as `SqlExecution`s so that it will be considered as a sink for queries like rb/sql-injection.

## 0.3.1

### Minor Analysis Improvements

* Fixed a bug causing every expression in the database to be considered a system-command execution sink when calls to any of the following methods exist:
  * The `spawn`, `fspawn`, `popen4`, `pspawn`, `system`, `_pspawn` methods and the backtick operator from the `POSIX::spawn` gem.
  * The `execute_command`, `rake`, `rails_command`, and `git` methods in `Rails::Generation::Actions`.
* Improved modeling of sensitive data sources, so common words like `certain` and `secretary` are no longer considered a certificate and a secret (respectively).

## 0.3.0

### Deprecated APIs

* The `BarrierGuard` class has been deprecated. Such barriers and sanitizers can now instead be created using the new `BarrierGuard` parameterized module.

## 0.2.3

### Minor Analysis Improvements

- Calls to `Zip::File.open` and `Zip::File.new` have been added as `FileSystemAccess` sinks. As a result queries like `rb/path-injection` now flag up cases where users may access arbitrary archive files.

## 0.2.2

### Major Analysis Improvements

* Added data-flow support for [hashes](https://docs.ruby-lang.org/en/3.1/Hash.html).

### Minor Analysis Improvements

* Support for data flow through instance variables has been added.
* Support of the safe navigation operator (`&.`) has been added; there is a new predicate `MethodCall.isSafeNavigation()`.

## 0.2.1

### Bug Fixes

* The Tree-sitter Ruby grammar has been updated; this fixes several issues where Ruby code was parsed incorrectly.

## 0.2.0

### Breaking Changes

* The signature of `allowImplicitRead` on `DataFlow::Configuration` and `TaintTracking::Configuration` has changed from `allowImplicitRead(DataFlow::Node node, DataFlow::Content c)` to `allowImplicitRead(DataFlow::Node node, DataFlow::ContentSet c)`.

## 0.1.0

### Breaking Changes

* The recently added flow-state versions of `isBarrierIn`, `isBarrierOut`, `isSanitizerIn`, and `isSanitizerOut` in the data flow and taint tracking libraries have been removed.
* The `getURL` member-predicates of the `HTTP::Client::Request` and `HTTP::Client::Request::Range` classes from `Concepts.qll` have been renamed to `getAUrlPart`.

### Deprecated APIs

* `ConstantValue::getStringOrSymbol` and `ConstantValue::isStringOrSymbol`, which return/hold for all string-like values (strings, symbols, and regular expressions), have been renamed to `ConstantValue::getStringlikeValue` and `ConstantValue::isStringlikeValue`, respectively. The old names have been marked as `deprecated`.

### Minor Analysis Improvements

* Whereas `ConstantValue::getString()` previously returned both string and regular-expression values, it now returns only string values. The same applies to `ConstantValue::isString(value)`.
* Regular-expression values can now be accessed with the new predicates `ConstantValue::getRegExp()`, `ConstantValue::isRegExp(value)`, and `ConstantValue::isRegExpWithFlags(value, flags)`.
* The `ParseRegExp` and `RegExpTreeView` modules are now "internal" modules. Users should use `codeql.ruby.Regexp` instead.

## 0.0.13

## 0.0.12

### Breaking Changes

* The flow state variants of `isBarrier` and `isAdditionalFlowStep` are no longer exposed in the taint tracking library. The `isSanitizer` and `isAdditionalTaintStep` predicates should be used instead.

### Deprecated APIs

* Many classes/predicates/modules that had upper-case acronyms have been renamed to follow our style-guide. 
  The old name still exists as a deprecated alias.

### New Features

* The data flow and taint tracking libraries have been extended with versions of `isBarrierIn`, `isBarrierOut`, and `isBarrierGuard`, respectively `isSanitizerIn`, `isSanitizerOut`, and `isSanitizerGuard`, that support flow states.

### Minor Analysis Improvements

* `getConstantValue()` now returns the contents of strings and symbols after escape sequences have been interpreted. For example, for the Ruby string literal `"\n"`, `getConstantValue().getString()` previously returned a QL string with two characters, a backslash followed by `n`; now it returns the single-character string "\n" (U+000A, known as newline).
* `getConstantValue().getInt()` previously returned incorrect values for integers larger than 2<sup>31</sup>-1 (the largest value that can be represented by the QL `int` type). It now returns no result in those cases.
* Added `OrmWriteAccess` concept to model data written to a database using an object-relational mapping (ORM) library.

## 0.0.11

### Minor Analysis Improvements

* The `Regex` class is now an abstract class that extends `StringlikeLiteral` with implementations for `RegExpLiteral` and string literals that 'flow' into functions that are known to interpret string arguments as regular expressions such as `Regex.new` and `String.match`.
* The regular expression parser now groups sequences of normal characters. This reduces the number of instances of `RegExpNormalChar`.

## 0.0.10

### Minor Analysis Improvements

* Added `FileSystemWriteAccess` concept to model data written to the filesystem.

## 0.0.9

## 0.0.8

## 0.0.7

## 0.0.6

### Deprecated APIs

* `ConstantWriteAccess.getQualifiedName()` has been deprecated in favor of `getAQualifiedName()` which can return multiple possible qualified names for a given constant write access.

## 0.0.5

### New Features

* A new library, `Customizations.qll`, has been added, which allows for global customizations that affect all queries.

## 0.0.4
