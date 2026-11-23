/**
 * @name Cleartext storage of sensitive information in a local database
 * @description Storing sensitive information in a non-encrypted
 *              database can expose it to an attacker.
 * @kind path-problem
 * @problem.severity warning
 * @security-severity 7.5
 * @precision high
 * @id unified/swift/cleartext-storage-database
 * @tags security
 *       external/cwe/cwe-312
 */

import unified
import codeql.unified.security.SensitiveData
private import codeql.unified.internal.typeinference.TypeInference as TypeInference

/**
 * Holds if `cls` is a subclass of `baseName`, including `baseName` itself.
 */
bindingset[baseName]
private predicate isSubclassOf(ClassLikeDeclaration cls, string baseName) {
  // TODO: if we want this predicate, it should probably be in a library?
  cls.getABaseClass*().getName() = baseName
}

/**
 * Holds if `node` is a value stored through a Core Data API.
 */
private predicate coreDataSink(DataFlow::Node node) {
  // values written into Core Data objects through `set*Value` methods are a sink.
  exists(CallExpr call, FunctionDeclaration target |
    target = TypeInference::resolveCallTarget(call) and
    isSubclassOf(target.getEnclosingClass(), "NSManagedObject") and
    target.getName() = ["setValue", "setPrimitiveValue"] and
    node.asExpr() = call.getArgument(0).getValue()
  )
  or
  // any write into a class derived from `NSManagedObject` is a sink. For
  // example in `coreDataObj.data = sensitive` the post-update node corresponding
  // with `coreDataObj.data` is a sink.
  // (ideally this would be only members with the `@NSManaged` attribute)
  exists(MemberAccessExpr access |
    (node.isIncomingValue(access) or node.isPostUpdate(access)) and
    isSubclassOf(TypeInference::inferType(access.getBase()).asClass(), "NSManagedObject")
    // TODO: original Swift had an exception for `SelfParamDecl` here.
  )
}

/**
 * Holds if `node` is a value assigned to a persisted Realm object.
 */
private predicate realmSink(DataFlow::Node node) {
  exists(MemberAccessExpr access |
    // `RealmSwiftObject`
    (node.isIncomingValue(access) or node.isPostUpdate(access)) and
    isSubclassOf(TypeInference::inferType(access.getBase()).asClass(), "RealmSwiftObject")
    //or
    // `Object`, when it is defined within `RealmSwift`.
    // TODO
  )
}

/**
 * A taint-tracking configuration for cleartext database storage vulnerabilities.
 */
module CleartextStorageDatabaseConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node node) { node instanceof SensitiveData }

  predicate isSink(DataFlow::Node node) {
    // There are relevant two sink types:
    // - an `sql-injection` sink is SQL or similar query data passed to a database operation.
    // - a `database-store` sink is non-query data passed to a database operation.
    // Keeping them separate is useful for the SQL injection query, whereas here we just want
    // both.
    Models::isSink(node, ["sql-injection", "database-store"])
    or
    coreDataSink(node)
    or
    realmSink(node)
  }

  predicate isBarrier(DataFlow::Node node) {
    // encrypted values are not cleartext.
    // TODO: pull the encryption logic out to a class `EncryptedExpr` as in original Swift;
    // we will certainly want this elsewhere.
    exists(CallExpr call, FunctionDeclaration target, Expr argument |
      target = TypeInference::resolveCallTarget(call) and
      target.getName().regexpMatch("(?is).*(crypt|hash|encode|protect).*") and
      argument = call.getAnArgument().getValue() and
      (
        node.asExpr() = argument
        or
        node.isPostUpdate(argument)
        or
        node.isPostUpdate(argument.(UnaryExpr).getOperand())
      )
    )
    or
    // booleans are more likely to be settings than actual sensitive data.
    TypeInference::inferType(node.asExpr()).asClass().getName() = "Bool"
    // TODO: Add models-as-data barriers.
  }

  predicate isBarrierIn(DataFlow::Node node) { isSource(node) }

  predicate isAdditionalFlowStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
    // propagate the taint from the base to the member access, e.g. from `sentitive` to `sensitive.field`
    nodeTo.asExpr().(MemberAccessExpr).getBase() = nodeFrom.asExpr()
  }

  // TODO: original Swift had two cases in `allowImplicitRead` we may wish to port over.
  predicate observeDiffInformedIncrementalMode() { any() }
}

module CleartextStorageDatabaseFlow = TaintTracking::Global<CleartextStorageDatabaseConfig>;

import CleartextStorageDatabaseFlow::PathGraph

from
  CleartextStorageDatabaseFlow::PathNode sourceNode, CleartextStorageDatabaseFlow::PathNode sinkNode
where CleartextStorageDatabaseFlow::flowPath(sourceNode, sinkNode)
select sinkNode.getNode(), sourceNode, sinkNode,
  "This database operation may read or write unencrypted sensitive data from $@.", sourceNode.getNode(),
  sourceNode.getNode().toString()
