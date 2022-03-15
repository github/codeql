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
