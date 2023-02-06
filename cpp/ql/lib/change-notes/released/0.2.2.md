## 0.2.2

### Deprecated APIs

 * The `AnalysedString` class in the `StringAnalysis` module has been replaced with `AnalyzedString`, to follow our style guide. The old name still exists as a deprecated alias.

### New Features

* A `getInitialization` predicate was added to the `ConstexprIfStmt`, `IfStmt`, and `SwitchStmt` classes that yields the C++17-style initializer of the `if` or `switch` statement when it exists.
