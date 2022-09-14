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
 * An `Expr` that is stored in a local database.
 */
abstract class Stored extends Expr { }

/**
 * An `Expr` that is stored with the Core Data library.
 */
class CoreDataStore extends Stored {
  CoreDataStore() {
    // `content` arg to `NWConnection.send` is a sink
    exists(ClassDecl c, AbstractFunctionDecl f, CallExpr call |
      c.getName() = "NSManagedObject" and
      c.getAMember() = f and
      f.getName() = ["setValue(_:forKey:)", "setPrimitiveValue(_:forKey:)"] and
      call.getStaticTarget() = f and
      call.getArgument(0).getExpr() = this
    )
  }
}

/**
 * An `Expr` that is stored with the Realm database library.
 */
class RealmStore extends Stored {
  RealmStore() {
    // `object` arg to `Realm.add` is a sink
    exists(ClassDecl c, AbstractFunctionDecl f, CallExpr call |
      c.getName() = "Realm" and
      c.getAMember() = f and
      f.getName() = "add(_:update:)" and
      call.getStaticTarget() = f and
      call.getArgument(0).getExpr() = this
    )
    or
    // `value` arg to `Realm.create` is a sink
    exists(ClassDecl c, AbstractFunctionDecl f, CallExpr call |
      c.getName() = "Realm" and
      c.getAMember() = f and
      f.getName() = "create(_:value:update:)" and
      call.getStaticTarget() = f and
      call.getArgument(1).getExpr() = this
    )
    or
    // any access into a class derived from `RealmSwiftObject` is a sink
    exists(ClassDecl cd |
      cd.getABaseTypeDecl*().getName() = "RealmSwiftObject" and
      this.getFullyConverted().getType() = cd.getType()
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

  override predicate isSink(DataFlow::Node node) { node.asExpr() instanceof Stored }

  override predicate isSanitizerIn(DataFlow::Node node) {
    // make sources barriers so that we only report the closest instance
    isSource(node)
  }

  override predicate isSanitizer(DataFlow::Node node) {
    // encryption barrier
    node.asExpr() instanceof EncryptedExpr
  }

  override predicate isAdditionalTaintStep(DataFlow::Node node1, DataFlow::Node node2) {
    // allow flow from a post-update node at the sink to the sink. For example
    // in `realmObj.data = sensitive` taint flows to the post-update node
    // corresponding with the  sink `realmObj.data`, and we want to consider it
    // as reaching that sink.
    node1.(DataFlow::PostUpdateNode).getPreUpdateNode() = node2 and
    isSink(node2)
  }

  override predicate allowImplicitRead(DataFlow::Node node, DataFlow::ContentSet c) {
    // flow out from fields of a `RealmSwiftObject` at the sink, for example in
    // `obj.var = tainted; sink(obj)`.
    (isSink(node) or isAdditionalTaintStep(node, _)) and
    exists(ClassDecl cd |
      c.getAReadContent().(DataFlow::Content::FieldContent).getField() = cd.getAMember() and
      cd.getABaseTypeDecl*().getName() = "RealmSwiftObject"
    )
    or
    // any default implicit reads
    super.allowImplicitRead(node, c)
  }
}

from CleartextStorageConfig config, DataFlow::PathNode sourceNode, DataFlow::PathNode sinkNode
where config.hasFlowPath(sourceNode, sinkNode)
select sinkNode.getNode(), sourceNode, sinkNode,
  "This operation stores '" + sinkNode.getNode().toString() +
    "' in a database. It may contain unencrypted sensitive data from $@", sourceNode,
  sourceNode.getNode().toString()
