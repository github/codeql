/**
 * @name Uncontrolled data used in path expression
 * @description Accessing paths influenced by users can allow an attacker to access unexpected resources.
 * @kind path-problem
 * @problem.severity error
 * @sub-severity high
 * @precision high
 * @id py/path-injection
 * @tags correctness
 *       security
 *       external/owasp/owasp-a1
 *       external/cwe/cwe-022
 *       external/cwe/cwe-023
 *       external/cwe/cwe-036
 *       external/cwe/cwe-073
 *       external/cwe/cwe-099
 */

import python
import experimental.dataflow.DataFlow
import experimental.dataflow.DataFlow2
import experimental.dataflow.TaintTracking
import experimental.dataflow.TaintTracking2
import experimental.semmle.python.Concepts
import experimental.dataflow.RemoteFlowSources
import DataFlow::PathGraph

/** Configuration to find paths from sources to sinks that contain no normalization. */
class UnNormalizedPathConfiguration extends TaintTracking::Configuration {
  UnNormalizedPathConfiguration() { this = "UnNormalizedPathConfiguration" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) {
    sink = any(FileSystemAccess e).getAPathArgument()
  }

  override predicate isSanitizer(DataFlow::Node node) { node instanceof PathNormalization }
}

/** Configuration to find paths from sources to normalizations that contain no prior normalizations. */
class FirstNormalizationConfiguration extends TaintTracking2::Configuration {
  FirstNormalizationConfiguration() { this = "FirstNormalizationConfiguration" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) { sink instanceof PathNormalization }

  override predicate isSanitizerOut(DataFlow::Node node) { node instanceof PathNormalization }
}

class FirstNormalization extends DataFlow2::PathNode {
  DataFlow::Node sourceNode;

  FirstNormalization() {
    exists(FirstNormalizationConfiguration conf, DataFlow2::PathNode source |
      sourceNode = source.getNode() and
      conf.hasFlowPath(source, this)
    )
  }

  DataFlow::Node getSourceNode() { result = sourceNode }
}

/** Configuration to find paths from normalizations to sinks that do not go through a check. */
class UncheckedNormalizedConfiguration extends TaintTracking::Configuration {
  UncheckedNormalizedConfiguration() { this = "UncheckedNormalizedConfiguration" }

  override predicate isSource(DataFlow::Node source) {
    source = any(FirstNormalization n).getNode()
  }

  override predicate isSink(DataFlow::Node sink) {
    sink = any(FileSystemAccess e).getAPathArgument()
  }

  override predicate isSanitizerGuard(DataFlow::BarrierGuard guard) { guard instanceof PathCheck }
}

from TaintTracking::Configuration config, DataFlow::PathNode source, DataFlow::PathNode sink
where
  // Path has no normalization on it.
  config instanceof UnNormalizedPathConfiguration and
  config.hasFlowPath(source, sink)
  or
  // Path has a normalization on it, but no subsequent check.
  config instanceof UncheckedNormalizedConfiguration and
  config.hasFlowPath(source, sink)
  or
  // This should report a better source, but does not quite work.
  // Path has a normalization on it, but no subsequent check.
  config instanceof UncheckedNormalizedConfiguration and
  exists(DataFlow::PathNode c, FirstNormalization n | n.getNode() = c.getNode() |
    config.hasFlowPath(c, sink) and
    source.getNode() = n.getSourceNode()
  )
select sink.getNode(), source, sink, "This path depends on $@.", source.getNode(),
  "a user-provided value"
