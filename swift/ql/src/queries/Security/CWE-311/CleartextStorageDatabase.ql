/**
 * @name Cleartext storage of sensitive information in a local database
 * @description Storing sensitive information in a non-encrypted
 *              database can expose it to an attacker.
 * @kind path-problem
 * @problem.severity warning
 * @security-severity 7.5
 * @precision medium
 * @id swift/cleartext-storage-database
 * @tags security
 *       external/cwe/cwe-312
 */

import swift
import codeql.swift.security.SensitiveExprs
import codeql.swift.dataflow.DataFlow
import codeql.swift.dataflow.TaintTracking
import DataFlow::PathGraph

/**
 * A `DataFlow::Node` that is something stored in a local database.
 */
abstract class Stored extends DataFlow::Node { }

/**
 * A `DataFlow::Node` that is an expression stored with the Core Data library.
 */
class CoreDataStore extends Stored {
  CoreDataStore() {
    // values written into Core Data objects are a sink
    exists(CallExpr call |
      call.getStaticTarget()
          .(MethodDecl)
          .hasQualifiedName("NSManagedObject",
            ["setValue(_:forKey:)", "setPrimitiveValue(_:forKey:)"]) and
      call.getArgument(0).getExpr() = this.asExpr()
    )
  }
}

/**
 * A `DataFlow::Node` that is an expression stored with the Realm database
 * library.
 */
class RealmStore extends Stored instanceof DataFlow::PostUpdateNode {
  RealmStore() {
    // any write into a class derived from `RealmSwiftObject` is a sink. For
    // example in `realmObj.data = sensitive` the post-update node corresponding
    // with `realmObj.data` is a sink.
    exists(ClassOrStructDecl cd, Expr e |
      cd.getABaseTypeDecl*().getName() = "RealmSwiftObject" and
      this.getPreUpdateNode().asExpr() = e and
      e.getFullyConverted().getType() = cd.getType() and
      not e.(DeclRefExpr).getDecl() instanceof SelfParamDecl
    )
  }
}

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

  override predicate allowImplicitRead(DataFlow::Node node, DataFlow::ContentSet c) {
    // flow out from fields of a `RealmSwiftObject` at the sink, for example in
    // `realmObj.data = sensitive`.
    isSink(node) and
    exists(ClassOrStructDecl cd |
      c.getAReadContent().(DataFlow::Content::FieldContent).getField() = cd.getAMember() and
      cd.getABaseTypeDecl*().getName() = "RealmSwiftObject"
    )
    or
    // any default implicit reads
    super.allowImplicitRead(node, c)
  }
}

/**
 * Gets a prettier node to use in the results.
 */
DataFlow::Node cleanupNode(DataFlow::Node n) {
  result = n.(DataFlow::PostUpdateNode).getPreUpdateNode()
  or
  not n instanceof DataFlow::PostUpdateNode and
  result = n
}

from CleartextStorageConfig config, DataFlow::PathNode sourceNode, DataFlow::PathNode sinkNode
where config.hasFlowPath(sourceNode, sinkNode)
select cleanupNode(sinkNode.getNode()), sourceNode, sinkNode,
  "This operation stores '" + sinkNode.getNode().toString() +
    "' in a database. It may contain unencrypted sensitive data from $@.", sourceNode,
  sourceNode.getNode().toString()
