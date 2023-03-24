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
