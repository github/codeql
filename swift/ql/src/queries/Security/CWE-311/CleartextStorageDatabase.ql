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
 * A `DataFlow::Node` that is an expression stored with the GRDB library.
 */
class GrdbStore extends Stored {
  GrdbStore() {
    exists(CallExpr call, MethodDecl method |
      call.getStaticTarget() = method and
      call.getArgumentWithLabel("arguments").getExpr() = this.asExpr()
    |
      method
          .hasQualifiedName("Database",
            ["allStatements(sql:arguments:)", "execute(sql:arguments:)",])
      or
      method.hasQualifiedName("SQLRequest", "init(sql:arguments:adapter:cached:)")
      or
      method.hasQualifiedName("SQL", ["init(sql:arguments:)", "append(sql:arguments:)"])
      or
      method.hasQualifiedName("SQLStatementCursor", "init(database:sql:arguments:prepFlags:)")
      or
      method
          .hasQualifiedName("TableRecord",
            [
              "select(sql:arguments:)", "select(sql:arguments:as:)", "filter(sql:arguments:)",
              "order(sql:arguments:)"
            ])
      or
      method
          .hasQualifiedName(["Row", "DatabaseValueConvertible", "FetchableRecord"],
            [
              "fetchCursor(_:sql:arguments:adapter:)", "fetchAll(_:sql:arguments:adapter:)",
              "fetchSet(_:sql:arguments:adapter:)", "fetchOne(_:sql:arguments:adapter:)"
            ])
      or
      method
          .hasQualifiedName("FetchableRecord",
            [
              "fetchCursor(_:arguments:adapter:)", "fetchAll(_:arguments:adapter:)",
              "fetchSet(_:arguments:adapter:)", "fetchOne(_:arguments:adapter:)",
            ])
      or
      method.hasQualifiedName("Statement", ["execute(arguments:)"])
      or
      method
          .hasQualifiedName("CommonTableExpression", "init(recursive:named:columns:sql:arguments:)")
    )
    or
    exists(CallExpr call, MethodDecl method |
      call.getStaticTarget() = method and
      call.getArgument(0).getExpr() = this.asExpr()
    |
      method.hasQualifiedName("Statement", "setArguments(_:)")
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

  override predicate isAdditionalTaintStep(DataFlow::Node node1, DataFlow::Node node2) {
    // Needed until we have proper content flow through arrays
    exists(ArrayExpr arr |
      node1.asExpr() = arr.getAnElement() and
      node2.asExpr() = arr
    )
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
