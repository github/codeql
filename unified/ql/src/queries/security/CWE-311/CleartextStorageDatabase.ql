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
  cls.getABaseClass*().getName() = baseName
}

/**
 * Holds if `node` is a value stored through a Core Data API.
 */
private predicate coreDataSink(DataFlow::Node node) {
  exists(CallExpr call, FunctionDeclaration target |
    target = TypeInference::resolveCallTarget(call) and
    isSubclassOf(target.getEnclosingClass(), "NSManagedObject") and
    target.getName() = ["setValue", "setPrimitiveValue"] and
    node.asExpr() = call.getArgument(0).getValue()
  )
  or
  exists(MemberAccessExpr access |
    node.isPostUpdate(access) and
    isSubclassOf(TypeInference::inferType(access.getBase()).asClass(), "NSManagedObject")
  )
}

/**
 * Holds if `node` is a value assigned to a persisted Realm object.
 */
private predicate realmSink(DataFlow::Node node) {
  exists(MemberAccessExpr access |
    node.isPostUpdate(access) and
    (
      isSubclassOf(TypeInference::inferType(access.getBase()).asClass(), "RealmSwiftObject")
      or
      // TODO: Match `RealmSwift.Object` without matching unrelated `Object` classes.
      none()
    )
  )
}

/**
 * A taint-tracking configuration for cleartext database storage vulnerabilities.
 */
module CleartextStorageDatabaseConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node node) { node instanceof SensitiveData }

  predicate isSink(DataFlow::Node node) {
    Models::isSink(node, ["database-store", "sql-injection"])
    or
    coreDataSink(node)
    or
    realmSink(node)
  }

  predicate isBarrier(DataFlow::Node node) {
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
    TypeInference::inferType(node.asExpr()).asClass().getName() = "Bool"
    // TODO: Add models-as-data barriers.
  }

  predicate isBarrierIn(DataFlow::Node node) { isSource(node) }

  predicate isAdditionalFlowStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
    nodeTo.asExpr().(MemberAccessExpr).getBase() = nodeFrom.asExpr()
  }

  predicate observeDiffInformedIncrementalMode() { any() }
}

module CleartextStorageDatabaseFlow = TaintTracking::Global<CleartextStorageDatabaseConfig>;

import CleartextStorageDatabaseFlow::PathGraph

from
  CleartextStorageDatabaseFlow::PathNode sourceNode, CleartextStorageDatabaseFlow::PathNode sinkNode
where CleartextStorageDatabaseFlow::flowPath(sourceNode, sinkNode)
select sinkNode.getNode(), sourceNode, sinkNode,
  "This operation stores unencrypted sensitive data from $@.", sourceNode.getNode(),
  sourceNode.getNode().toString()
