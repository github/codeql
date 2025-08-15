/**
 * @name Log injection
 * @description Building log entries from user-controlled sources is vulnerable to
 *              insertion of forged log entries by a malicious user.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 2.6
 * @precision medium
 * @id rust/log-injection
 * @tags security
 *       external/cwe/cwe-117
 */

import rust
import codeql.rust.dataflow.DataFlow
import codeql.rust.dataflow.TaintTracking
import codeql.rust.security.LogInjectionExtensions

/**
 * A taint configuration for tainted data that reaches a log injection sink.
 */
module LogInjectionConfig implements DataFlow::ConfigSig {
  import LogInjection

  predicate isSource(DataFlow::Node node) { node instanceof Source }

  predicate isSink(DataFlow::Node node) { node instanceof Sink }

  predicate isBarrier(DataFlow::Node barrier) { barrier instanceof Barrier }

  predicate observeDiffInformedIncrementalMode() { any() }
}

module LogInjectionFlow = TaintTracking::Global<LogInjectionConfig>;

import LogInjectionFlow::PathGraph

from LogInjectionFlow::PathNode sourceNode, LogInjectionFlow::PathNode sinkNode
where LogInjectionFlow::flowPath(sourceNode, sinkNode)
select sinkNode.getNode(), sourceNode, sinkNode, "Log entry depends on a $@.", sourceNode.getNode(),
  "user-provided value"
