## 0.7.0

### Breaking Changes

* The internal `SsaConsistency` module has been moved from `SSAConstruction` to `SSAConsitency`, and the deprecated `SSAConsistency` module has been removed.

### Deprecated APIs

* The single-parameter predicates `ArrayOrVectorAggregateLiteral.getElementExpr` and `ClassAggregateLiteral.getFieldExpr` have been deprecated in favor of `ArrayOrVectorAggregateLiteral.getAnElementExpr` and `ClassAggregateLiteral.getAFieldExpr`.
* The recently introduced new data flow and taint tracking APIs have had a
  number of module and predicate renamings. The old APIs remain in place for
  now.
* The `SslContextCallAbstractConfig`, `SslContextCallConfig`, `SslContextCallBannedProtocolConfig`, `SslContextCallTls12ProtocolConfig`, `SslContextCallTls13ProtocolConfig`, `SslContextCallTlsProtocolConfig`, `SslContextFlowsToSetOptionConfig`, `SslOptionConfig` dataflow configurations from `BoostorgAsio` have been deprecated. Please use `SslContextCallConfigSig`, `SslContextCallGlobal`, `SslContextCallFlow`, `SslContextCallBannedProtocolFlow`, `SslContextCallTls12ProtocolFlow`, `SslContextCallTls13ProtocolFlow`, `SslContextCallTlsProtocolFlow`, `SslContextFlowsToSetOptionFlow`.

### New Features

* Added overridable predicates `getSizeExpr` and `getSizeMult` to the `BufferAccess` class (`semmle.code.cpp.security.BufferAccess.qll`). This makes it possible to model a larger class of buffer reads and writes using the library.

### Minor Analysis Improvements

* The `BufferAccess` library (`semmle.code.cpp.security.BufferAccess`) no longer matches buffer accesses inside unevaluated contexts (such as inside `sizeof` or `decltype` expressions). As a result, queries using this library may see fewer false positives.

### Bug Fixes

* Fixed some accidental predicate visibility in the backwards-compatible wrapper for data flow configurations. In particular `DataFlow::hasFlowPath`, `DataFlow::hasFlow`, `DataFlow::hasFlowTo`, and `DataFlow::hasFlowToExpr` were accidentally exposed in a single version.
