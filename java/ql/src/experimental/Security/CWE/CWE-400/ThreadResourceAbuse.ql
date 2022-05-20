/**
 * @name Uncontrolled thread resource consumption
 * @description Using user input directly to control a thread's sleep time could lead to
 *              performance problems or even resource exhaustion.
 * @kind path-problem
 * @id java/thread-resource-abuse
 * @problem.severity warning
 * @tags security
 *       external/cwe/cwe-400
 */

import java
import ThreadResourceAbuse
import semmle.code.java.dataflow.FlowSources
import DataFlow::PathGraph

/** Taint configuration of uncontrolled thread resource consumption. */
class ThreadResourceAbuse extends TaintTracking::Configuration {
  ThreadResourceAbuse() { this = "ThreadResourceAbuse" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) { sink instanceof PauseThreadSink }

  override predicate isAdditionalTaintStep(DataFlow::Node pred, DataFlow::Node succ) {
    any(AdditionalValueStep r).step(pred, succ)
  }

  override predicate isSanitizer(DataFlow::Node node) {
    exists(
      MethodAccess ma // Math.min(sleepTime, MAX_INTERVAL)
    |
      ma.getMethod().hasQualifiedName("java.lang", "Math", "min") and
      node.asExpr() = ma.getAnArgument()
    )
  }

  override predicate isSanitizerGuard(DataFlow::BarrierGuard guard) {
    guard instanceof LessThanSanitizer // if (sleepTime > 0 && sleepTime < 5000) { ... }
  }
}

from DataFlow::PathNode source, DataFlow::PathNode sink, ThreadResourceAbuse conf
where conf.hasFlowPath(source, sink)
select sink.getNode(), source, sink,
  "Vulnerability of uncontrolled resource consumption due to $@.", source.getNode(),
  "user-provided value"
