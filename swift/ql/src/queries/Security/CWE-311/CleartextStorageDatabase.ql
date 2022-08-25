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
      call.getFunction().(ApplyExpr).getStaticTarget() = f and
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
      f.getName() = ["add(_:update:)"] and
      call.getFunction().(ApplyExpr).getStaticTarget() = f and
      call.getArgument(0).getExpr() = this
    )
    or
    // `value` arg to `Realm.create` is a sink
    exists(ClassDecl c, AbstractFunctionDecl f, CallExpr call |
      c.getName() = "Realm" and
      c.getAMember() = f and
      f.getName() = ["create(_:value:update:)"] and
      call.getFunction().(ApplyExpr).getStaticTarget() = f and
      call.getArgument(1).getExpr() = this
    )
  }
}

/**
 * A taint configuration from sensitive information to expressions that are
 * transmitted over a network.
 */
class CleartextStorageConfig extends TaintTracking::Configuration {
  CleartextStorageConfig() { this = "CleartextStorageConfig" }

  override predicate isSource(DataFlow::Node node) {
    exists(SensitiveExpr e |
      node.asExpr() = e and
      not e.isProbablySafe()
    )
  }

  override predicate isSink(DataFlow::Node node) { node.asExpr() instanceof Stored }

  override predicate isSanitizerIn(DataFlow::Node node) {
    // make sources barriers so that we only report the closest instance
    isSource(node)
  }

  override predicate isAdditionalTaintStep(DataFlow::Node node1, DataFlow::Node node2) {
    // TODO: the following special case flows are required to catch any of the Realm test
    // cases, I hope we'll be able to remove them once we have field flow???
    // flow out from field accesses, i.e. `a.b` -> `a`
    exists(MemberRefExpr m |
      node1.asExpr() = m and // `a.b`
      node2.asExpr() = m.getBaseExpr() // `a`
    )
    or
    // flow through assignment (!)
    exists(AssignExpr ae |
      node1.asExpr() = ae.getSource() and
      node2.asExpr() = ae.getDest()
    )
  }
}

from CleartextStorageConfig config, DataFlow::PathNode sourceNode, DataFlow::PathNode sinkNode
where config.hasFlowPath(sourceNode, sinkNode)
select sinkNode.getNode(), sourceNode, sinkNode,
  "This operation stores '" + sinkNode.getNode().toString() +
    "' in a database. It may contain unencrypted sensitive data from $@", sourceNode,
  sourceNode.getNode().toString()
