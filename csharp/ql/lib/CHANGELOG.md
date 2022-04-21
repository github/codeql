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
