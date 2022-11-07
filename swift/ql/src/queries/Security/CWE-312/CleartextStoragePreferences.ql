/**
 * @name Cleartext storage of sensitive information in an application preference store
 * @description Storing sensitive information in a non-encrypted store can expose it to an attacker.
 * @kind path-problem
 * @problem.severity warning
 * @security-severity 7.5
 * @precision medium
 * @id swift/cleartext-storage-preferences
 * @tags security
 *       external/cwe/cwe-312
 */

import swift
import codeql.swift.security.SensitiveExprs
import codeql.swift.dataflow.DataFlow
import codeql.swift.dataflow.TaintTracking
import DataFlow::PathGraph

/**
 * A `DataFlow::Node` of something that gets stored in an application preference store.
 */
abstract class Stored extends DataFlow::Node {
  abstract string getStoreName();
}

/** The `DataFlow::Node` of an expression that gets written to the user defaults database */
class UserDefaultsStore extends Stored {
  UserDefaultsStore() {
    exists(CallExpr call |
      call.getStaticTarget().(MethodDecl).hasQualifiedName("UserDefaults", "set(_:forKey:)") and
      call.getArgument(0).getExpr() = this.asExpr()
    )
  }

  override string getStoreName() { result = "the user defaults database" }
}

/** The `DataFlow::Node` of an expression that gets written to the iCloud-backed NSUbiquitousKeyValueStore */
class NSUbiquitousKeyValueStore extends Stored {
  NSUbiquitousKeyValueStore() {
    exists(CallExpr call |
      call.getStaticTarget()
          .(MethodDecl)
          .hasQualifiedName("NSUbiquitousKeyValueStore", "set(_:forKey:)") and
      call.getArgument(0).getExpr() = this.asExpr()
    )
  }

  override string getStoreName() { result = "iCloud" }
}

/**
 * A more complicated case, this is a macOS-only way of writing to
 * NSUserDefaults by modifying the `NSUserDefaultsController.values: Any`
 * object via reflection (`perform(Selector)`) or the `NSKeyValueCoding`,
 * `NSKeyValueBindingCreation` APIs. (TODO)
 */
class NSUserDefaultsControllerStore extends Stored {
  NSUserDefaultsControllerStore() { none() }

  override string getStoreName() { result = "the user defaults database" }
}

/**
 * A taint configuration from sensitive information to expressions that are
 * stored as preferences.
 */
class CleartextStorageConfig extends TaintTracking::Configuration {
  CleartextStorageConfig() { this = "CleartextStorageConfig" }

  override predicate isSource(DataFlow::Node node) { node.asExpr() instanceof SensitiveExpr }

  override predicate isSink(DataFlow::Node node) { node instanceof Stored }

  override predicate isSanitizerIn(DataFlow::Node node) {
    // make sources barriers so that we only report the closest instance
    this.isSource(node)
  }

  override predicate isSanitizer(DataFlow::Node node) {
    // encryption barrier
    node.asExpr() instanceof EncryptedExpr
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
  "This operation stores '" + sinkNode.getNode().toString() + "' in " +
    sinkNode.getNode().(Stored).getStoreName() +
    ". It may contain unencrypted sensitive data from $@.", sourceNode,
  sourceNode.getNode().toString()
