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
class CleartextStorageConfig extends TaintTracking::Configuration {
  CleartextStorageConfig() { this = "CleartextStorageConfig" }

  override predicate isSource(DataFlow::Node node) { node.asExpr() instanceof SensitiveExpr }

  override predicate isSink(DataFlow::Node node) { node instanceof Stored }

  override predicate isSanitizerIn(DataFlow::Node node) {
    // make sources barriers so that we only report the closest instance
    isSource(node)
  }

  override predicate isSanitizer(DataFlow::Node node) {
    // encryption barrier
    node.asExpr() instanceof EncryptedExpr
  }

  override predicate isAdditionalTaintStep(DataFlow::Node node1, DataFlow::Node node2) {
    // Needed until we have proper content flow through arrays
    exists(ArrayExpr arr |
      node1.asExpr() = arr.getAnElement() and
      node2.asExpr() = arr
    )
  }

  override predicate allowImplicitRead(DataFlow::Node node, DataFlow::ContentSet c) {
    // flow out from fields of an `NSManagedObject` or `RealmSwiftObject` at the sink,
    // for example in `realmObj.data = sensitive`.
    isSink(node) and
    exists(ClassOrStructDecl cd, Decl cx |
      cd.getABaseTypeDecl*().getName() = ["NSManagedObject", "RealmSwiftObject"] and
      cx.asNominalTypeDecl() = cd and
      c.getAReadContent().(DataFlow::Content::FieldContent).getField() = cx.getAMember()
    )
    or
    // any default implicit reads
    super.allowImplicitRead(node, c)
  }
}
