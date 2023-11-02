## 0.8.1

### Minor Analysis Improvements

* Deleted the deprecated `isBarrierGuard` predicate from the dataflow library and its uses, use `isBarrier` and the `BarrierGuard` module instead.

## 0.8.0

No user-facing changes.

## 0.7.5

No user-facing changes.

## 0.7.4

### Minor Analysis Improvements

* The `--nostdlib` extractor option for the standalone extractor has been removed.

## 0.7.3

### Minor Analysis Improvements

* The query library for `cs/hardcoded-credentials` now excludes benign properties such as `UserNameClaimType` and `AllowedUserNameCharacters` from `Microsoft.AspNetCore.Identity` options classes.

## 0.7.2

No user-facing changes.

## 0.7.1

### New Features

* The `DataFlow::StateConfigSig` signature module has gained default implementations for `isBarrier/2` and `isAdditionalFlowStep/4`. 
  Hence it is no longer needed to provide `none()` implementations of these predicates if they are not needed.

### Minor Analysis Improvements

* Data flow configurations can now include a predicate `neverSkip(Node node)`
  in order to ensure inclusion of certain nodes in the path explanations. The
  predicate defaults to the end-points of the additional flow steps provided in
  the configuration, which means that such steps now always are visible by
  default in path explanations.

## 0.7.0

### Major Analysis Improvements

* The data flow library now performs type strengthening. This increases precision for all data flow queries by excluding paths that can be inferred to be impossible due to incompatible types.

### Minor Analysis Improvements

* Additional support for `command-injection`, `ldap-injection`, `log-injection`, and `url-redirection` sink kinds for Models as Data.

## 0.6.4

No user-facing changes.

## 0.6.3

### Major Analysis Improvements

* The extractor has been changed to run after the traced compiler call. This allows inspecting compiler generated files, such as the output of source generators. With this change, `.cshtml` files and their generated `.cshtml.g.cs` counterparts are extracted on dotnet 6 and above.

### Minor Analysis Improvements

* C#: Analysis of the `dotnet test` command supplied with a `dll` or `exe` file as argument no longer fails due to the addition of an erroneous `-p:SharedCompilation=false` argument.
* Deleted the deprecated `WebConfigXML`, `ConfigurationXMLElement`, `LocationXMLElement`, `SystemWebXMLElement`, `SystemWebServerXMLElement`, `CustomErrorsXMLElement`, and `HttpRuntimeXMLElement` classes from `WebConfig.qll`. The non-deprecated names with PascalCased Xml suffixes should be used instead.
* Deleted the deprecated `Record` class from both `Types.qll` and `Type.qll`.
* Deleted the deprecated `StructuralComparisonConfiguration` class from `StructuralComparison.qll`, use `sameGvn` instead.
* Deleted the deprecated `isParameterOf` predicate from the `ParameterNode` class.
* Deleted the deprecated `SafeExternalAPICallable`, `ExternalAPIDataNode`, `UntrustedDataToExternalAPIConfig`, `UntrustedExternalAPIDataNode`, and `ExternalAPIUsedWithUntrustedData` classes from `ExternalAPIsQuery.qll`. The non-deprecated names with PascalCased Api suffixes should be used instead.
* Updated the following C# sink kind names. Any custom data extensions that use these sink kinds will need to be updated accordingly in order to continue working.
  * `code` to `code-injection`
  * `sql` to `sql-injection`
  * `html` to `html-injection`
  * `xss` to `js-injection`
  * `remote` to `file-content-store`

## 0.6.2

### Minor Analysis Improvements

* The `cs/log-forging`, `cs/cleartext-storage`, and `cs/exposure-of-sensitive-information` queries now correctly handle unsanitized arguments to `ILogger` extension methods.
* Updated the `neutralModel` extensible predicate to include a `kind` column.

## 0.6.1

No user-facing changes.

## 0.6.0

### Deprecated APIs

* The recently introduced new data flow and taint tracking APIs have had a
  number of module and predicate renamings. The old APIs remain in place for
  now.

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

* Deleted the deprecated `getPath` and `getFolder` predicates from the `XmlFile` class.
* Deleted the deprecated `getAssertionIndex`, and `getAssertedParameter` predicates from the `AssertMethod` class.
* Deleted the deprecated `OverridableMethod` and `OverridableAccessor` classes.
* The `unsafe` predicate for `Modifiable` has been extended to cover delegate return types and identify pointer-like types at any nest level. This is relevant for `unsafe` declarations extracted from assemblies.

## 0.5.4

### Minor Analysis Improvements

* The query `cs/static-field-written-by-instance` is updated to handle properties.
* C# 11: Support for explicit interface member implementation of operators.
* The extraction of member modifiers has been generalized, which could lead to the extraction of more modifiers.
* C# 11: Added extractor and library support for `file` scoped types.
* C# 11: Added extractor support for `required` fields and properties.
* C# 11: Added library support for `checked` operators.

## 0.5.3

### Minor Analysis Improvements

* C# 11: Added extractor support for the `scoped` modifier annotation on parameters and local variables.

## 0.5.2

### Major Analysis Improvements

* Add extractor and library support for UTF-8 encoded strings.
* The `StringLiteral` class includes UTF-8 encoded strings.
* In the DB Scheme `@string_literal_expr` is renamed to `@utf16_string_literal_expr`.

### Minor Analysis Improvements

* C# 11: Added extractor support for `ref` fields in `ref struct` declarations.

## 0.5.1

### Major Analysis Improvements

* Added library support for generic attributes (also for CIL extracted attributes).
* `cil.ConstructedType::getName` was changed to include printing of the type arguments.

### Minor Analysis Improvements

* Attributes on methods in CIL are now extracted (Bugfix).
* Support for `static virtual` and `static abstract` interface members.
* Support for *operators* in interface definitions. 
* C# 11: Added support for the unsigned right shift `>>>` and unsigned right shift assignment `>>>=` operators.
* Query id's have been aligned such that they are prefixed with `cs` instead of `csharp`.

## 0.5.0

### Minor Analysis Improvements

* C# 11: Added support for list- and slice patterns in the extractor.
* Deleted the deprecated `getNameWithoutBrackets` predicate from the `ValueOrRefType` class in `Type.qll`.
* `Element::hasQualifiedName/1` has been deprecated. Use `hasQualifiedName/2` or `hasQualifiedName/3` instead.
* Added TCP/UDP sockets as taint sources.

## 0.4.6

No user-facing changes.

## 0.4.5

No user-facing changes.

## 0.4.4

### Minor Analysis Improvements

* The `[Summary|Sink|Source]ModelCsv` classes have been deprecated and Models as Data models are defined as data extensions instead.

## 0.4.3

No user-facing changes.

## 0.4.2

No user-facing changes.

## 0.4.1

### Minor Analysis Improvements

* `DateTime` expressions are now considered simple type sanitizers. This affects a wide range of security queries.
* ASP.NET Core controller definition has been made more precise. The amount of introduced taint sources or eliminated false positives should be low though, since the most common pattern is to derive all user defined ASP.NET Core controllers from the standard Controller class, which is not affected. 

## 0.4.0

### Deprecated APIs

* Some classes/modules with upper-case acronyms in their name have been renamed to follow our style-guide. 
  The old name still exists as a deprecated alias.

### Bug Fixes

* Fixed an issue in the taint tracking analysis where implicit reads were not allowed by default in sinks or additional taint steps that used flow states.

## 0.3.5

## 0.3.4

### Deprecated APIs

* Many classes/predicates/modules with upper-case acronyms in their name have been renamed to follow our style-guide. 
  The old name still exists as a deprecated alias.

### Minor Analysis Improvements

* All deprecated predicates/classes/modules that have been deprecated for over a year have been deleted.

## 0.3.3

## 0.3.2

## 0.3.1

## 0.3.0

### Deprecated APIs

* The `BarrierGuard` class has been deprecated. Such barriers and sanitizers can now instead be created using the new `BarrierGuard` parameterized module.

## 0.2.3

## 0.2.2

## 0.2.1

## 0.2.0

### Breaking Changes

* The signature of `allowImplicitRead` on `DataFlow::Configuration` and `TaintTracking::Configuration` has changed from `allowImplicitRead(DataFlow::Node node, DataFlow::Content c)` to `allowImplicitRead(DataFlow::Node node, DataFlow::ContentSet c)`.

## 0.1.0

### Breaking Changes

* The recently added flow-state versions of `isBarrierIn`, `isBarrierOut`, `isSanitizerIn`, and `isSanitizerOut` in the data flow and taint tracking libraries have been removed.

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

* All deprecated predicates/classes/modules that have been deprecated for over a year have been deleted.

## 0.0.11

### Breaking Changes

* The C# extractor no longer supports the following legacy environment variables:
```
ODASA_BUILD_ERROR_DIR
ODASA_CSHARP_LAYOUT
ODASA_SNAPSHOT
SEMMLE_DIST
SEMMLE_EXTRACTOR_OPTIONS
SEMMLE_PLATFORM_TOOLS
SEMMLE_PRESERVE_SYMLINKS
SOURCE_ARCHIVE
TRAP_FOLDER
```
* `codeql test run` now extracts source code recursively from sub folders. This may break existing tests that have other tests in nested sub folders, as those will now get the nested test code included.

## 0.0.10

## 0.0.9

### Major Analysis Improvements

* Added support for C# 10 lambda improvements
  * Explicit return types on lambda expressions.
  * Lambda expression can be tagged with method and return value attributes.
* Added support for C# 10 [Extended property patterns](https://docs.microsoft.com/en-us/dotnet/csharp/whats-new/csharp-10#extended-property-patterns).
* Return value attributes are extracted.
* The QL `Attribute` class now has subclasses for each kind of attribute.

## 0.0.8

### Deprecated APIs

* The `codeql/csharp-upgrades` CodeQL pack has been removed. All upgrades scripts have been merged into the `codeql/csharp-all` CodeQL pack.

### Major Analysis Improvements

Added support for the following C# 10 features.
* [Record structs](https://docs.microsoft.com/en-us/dotnet/csharp/whats-new/csharp-10#record-structs).
* [Improvements of structure types](https://docs.microsoft.com/en-us/dotnet/csharp/whats-new/csharp-10#improvements-of-structure-types).
  * Instance parameterless constructor in a structure type.
  * Enhance `WithExpr` in QL to support `structs` and anonymous classes.
* [Global using directives](https://docs.microsoft.com/en-us/dotnet/csharp/whats-new/csharp-10#global-using-directives).
* [File-scoped namespace declaration](https://docs.microsoft.com/en-us/dotnet/csharp/whats-new/csharp-10#file-scoped-namespace-declaration).
* [Enhanced #line pragma](https://docs.microsoft.com/en-us/dotnet/csharp/whats-new/csharp-10#enhanced-line-pragma).

### Minor Analysis Improvements

* The query `cs/local-shadows-member` no longer highlights parameters of `record` types.

## 0.0.7

## 0.0.6

## 0.0.5

## 0.0.4
