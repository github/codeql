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
module CleartextStorageDatabaseConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node node) { node.asExpr() instanceof SensitiveExpr }

  predicate isSink(DataFlow::Node node) { node instanceof CleartextStorageDatabaseSink }

  predicate isBarrier(DataFlow::Node barrier) { barrier instanceof CleartextStorageDatabaseBarrier }

  predicate isAdditionalFlowStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
    any(CleartextStorageDatabaseAdditionalFlowStep s).step(nodeFrom, nodeTo)
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
      (
        d.getType().getUnderlyingType().getABaseType*().getName() = "NSManagedObject" or
        d.getType() instanceof RealmSwiftObjectType
      ) and
      cx.asNominalTypeDecl() = d and
      c.getAReadContent().(DataFlow::Content::FieldContent).getField() = cx.getAMember()
    )
    or
    // flow out from dictionary tuple values at the sink (this is essential
    // for some of the SQLite.swift models).
    isSink(node) and
    node.asExpr().getType().getUnderlyingType() instanceof DictionaryType and
    c.getAReadContent().(DataFlow::Content::TupleContent).getIndex() = 1
  }
}

/**
 * Detect taint flow of sensitive information to expressions that are
 * transmitted over a network.
 */
module CleartextStorageDatabaseFlow = TaintTracking::Global<CleartextStorageDatabaseConfig>;
