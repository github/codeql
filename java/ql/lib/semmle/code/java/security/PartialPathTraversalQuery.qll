/** Provides taint tracking configurations to be used in partial path traversal queries. */

import java
import semmle.code.java.security.PartialPathTraversal
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.dataflow.FlowSources

/**
 * A taint-tracking configuration for unsafe user input
 * that is used to validate against path traversal, but is insufficient
 * and remains vulnerable to Partial Path Traversal.
 */
class PartialPathTraversalFromRemoteConfig extends TaintTracking::Configuration {
  PartialPathTraversalFromRemoteConfig() { this = "PartialPathTraversalFromRemoteConfig" }

  override predicate isSource(DataFlow::Node node) { node instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node node) {
    any(PartialPathTraversalMethodAccess ma).getQualifier() = node.asExpr()
  }
}
