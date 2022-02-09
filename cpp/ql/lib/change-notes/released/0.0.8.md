## 0.0.8

### Deprecated APIs

* The `codeql/cpp-upgrades` CodeQL pack has been removed. All upgrades scripts have been merged into the `codeql/cpp-all` CodeQL pack.

### Minor Analysis Improvements

* `FormatLiteral::getMaxConvertedLength` now uses range analysis to provide a
  more accurate length for integers formatted with `%x`
