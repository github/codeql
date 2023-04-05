/**
 * Provides a taint-tracking configuration for reasoning about cleartext
 * database storage vulnerabilities.
 */

import swift
import codeql.swift.security.SensitiveExprs
import codeql.swift.dataflow.DataFlow
import codeql.swift.dataflow.TaintTracking
import codeql.swift.security.CleartextStorageDatabaseExtensions

/**
 * A taint configuration from sensitive information to expressions that are
 * transmitted over a network.
 */
deprecated class CleartextStorageConfig extends TaintTracking::Configuration {
  CleartextStorageConfig() { this = "CleartextStorageConfig" }

  override predicate isSource(DataFlow::Node node) { node.asExpr() instanceof SensitiveExpr }

  override predicate isSink(DataFlow::Node node) { node instanceof CleartextStorageDatabaseSink }

  override predicate isSanitizer(DataFlow::Node sanitizer) {
    sanitizer instanceof CleartextStorageDatabaseSanitizer
  }

  override predicate isAdditionalTaintStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
    any(CleartextStorageDatabaseAdditionalTaintStep s).step(nodeFrom, nodeTo)
  }

  override predicate isSanitizerIn(DataFlow::Node node) {
    // make sources barriers so that we only report the closest instance
    isSource(node)
  }

  override predicate allowImplicitRead(DataFlow::Node node, DataFlow::ContentSet c) {
    // flow out from fields of an `NSManagedObject` or `RealmSwiftObject` at the sink,
    // for example in `realmObj.data = sensitive`.
    isSink(node) and
    exists(NominalTypeDecl d, Decl cx |
      d.getType().getABaseType*().getUnderlyingType().getName() =
        ["NSManagedObject", "RealmSwiftObject"] and
      cx.asNominalTypeDecl() = d and
      c.getAReadContent().(DataFlow::Content::FieldContent).getField() = cx.getAMember()
    )
    or
    // any default implicit reads
    super.allowImplicitRead(node, c)
  }
}

/**
 * A taint configuration from sensitive information to expressions that are
 * transmitted over a network.
 */
module CleartextStorageConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node node) { node.asExpr() instanceof SensitiveExpr }

  predicate isSink(DataFlow::Node node) { node instanceof CleartextStorageDatabaseSink }

  predicate isBarrier(DataFlow::Node sanitizer) {
    sanitizer instanceof CleartextStorageDatabaseSanitizer
  }

  predicate isAdditionalFlowStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
    any(CleartextStorageDatabaseAdditionalTaintStep s).step(nodeFrom, nodeTo)
  }

  predicate isBarrierIn(DataFlow::Node node) {
    // make sources barriers so that we only report the closest instance
    isSource(node)
  }

  predicate allowImplicitRead(DataFlow::Node node, DataFlow::ContentSet c) {
    // flow out from fields of an `NSManagedObject` or `RealmSwiftObject` at the sink,
    // for example in `realmObj.data = sensitive`.
    isSink(node) and
    exists(NominalTypeDecl d, Decl cx |
      d.getType().getABaseType*().getUnderlyingType().getName() =
        ["NSManagedObject", "RealmSwiftObject"] and
      cx.asNominalTypeDecl() = d and
      c.getAReadContent().(DataFlow::Content::FieldContent).getField() = cx.getAMember()
    )
  }
}

/**
 * Detect taint flow of sensitive information to expressions that are
 * transmitted over a network.
 */
module CleartextStorageFlow = TaintTracking::Global<CleartextStorageConfig>;
