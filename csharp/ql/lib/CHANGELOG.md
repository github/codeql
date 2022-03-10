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
