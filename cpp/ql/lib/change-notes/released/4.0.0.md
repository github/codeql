## 4.0.0

### Breaking Changes

* Deleted the deprecated `getAllocatorCall` predicate from `DeleteOrDeleteArrayExpr`, use `getDeallocatorCall` instead.

### New Features

* A new predicate `getOffsetInClass` was added to the `Field` class, which computes the byte offset of a field relative to a given `Class`.
* New classes `PreprocessorElifdef` and `PreprocessorElifndef` were introduced, which represents the C23/C++23 `#elifdef` and `#elifndef` preprocessor directives.
* A new class `TypeLibraryImport` was introduced, which represents the `#import` preprocessor directive as used by the Microsoft Visual C++ for importing type libraries.
