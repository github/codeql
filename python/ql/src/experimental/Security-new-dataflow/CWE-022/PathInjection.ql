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

/** Configuration to find paths from sources to sinks that contain no checks. */
class UncheckedPathConfiguration extends TaintTracking::Configuration {
  UncheckedPathConfiguration() { this = "UncheckedPathConfiguration" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) {
    sink = any(FileSystemAccess e).getAPathArgument()
  }

  override predicate isSanitizer(DataFlow::Node node) { node instanceof PathCheck }
}

/** Configuration to find paths from sources to checks that contain no normalization. */
class CheckUnnormalizedConfiguration extends TaintTracking2::Configuration {
  CheckUnnormalizedConfiguration() { this = "CheckUnnormalizedConfiguration" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) { sink instanceof PathCheck }

  override predicate isSanitizer(DataFlow::Node node) { node instanceof PathNormalization }
}

class CheckUnnormalized extends DataFlow2::PathNode {
  DataFlow::Node sourceNode;

  CheckUnnormalized() {
    exists(CheckUnnormalizedConfiguration conf, DataFlow2::PathNode source |
      sourceNode = source.getNode() and
      conf.hasFlowPath(source, this)
    )
  }

  DataFlow::Node getSourceNode() { result = sourceNode }
}

/** Configuration to find paths from checks to sinks that contain no further checks. */
class LastCheckConfiguration extends TaintTracking::Configuration {
  LastCheckConfiguration() { this = "UncheckedPathConfiguration" }

  override predicate isSource(DataFlow::Node source) {
    source = any(CheckUnnormalized cu).getNode()
  }

  override predicate isSink(DataFlow::Node sink) {
    sink = any(FileSystemAccess e).getAPathArgument()
  }

  override predicate isSanitizer(DataFlow::Node node) { node instanceof PathCheck }
}

from TaintTracking::Configuration config, DataFlow::PathNode source, DataFlow::PathNode sink
where
  // Path has no check on it.
  config instanceof UncheckedPathConfiguration and
  config.hasFlowPath(source, sink)
  or
  // Path has a check on it, but no prior normalization.
  config instanceof LastCheckConfiguration and
  exists(DataFlow::PathNode c, CheckUnnormalized cu | cu.getNode() = c.getNode() |
    config.hasFlowPath(c, sink) and
    source.getNode() = cu.getSourceNode()
  )
select sink.getNode(), source, sink, "This path depends on $@.", source.getNode(),
  "a user-provided value"
