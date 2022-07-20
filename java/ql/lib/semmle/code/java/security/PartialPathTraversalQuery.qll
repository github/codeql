import java
import semmle.code.java.security.PartialPathTraversal
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.dataflow.ExternalFlow
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.dataflow.FlowSources

class PartialPathTraversalFromRemoteConfig extends TaintTracking::Configuration {
    PartialPathTraversalFromRemoteConfig() { this = "PartialPathTraversalFromRemoteConfig" }

  override predicate isSource(DataFlow::Node node) { node instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node node) {
    any(PartialPathTraversalMethodAccess ma).getQualifier() = node.asExpr()
  }
}
