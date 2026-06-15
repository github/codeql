/**
 * @name Uncontrolled thread resource consumption
 * @description Using user input directly to control a thread's sleep time could lead to
 *              performance problems or even resource exhaustion.
 * @kind path-problem
 * @id java/thread-resource-abuse
 * @problem.severity warning
 * @tags security
 *       experimental
 *       external/cwe/cwe-400
 */

import java
deprecated import ThreadResourceAbuse
import semmle.code.java.dataflow.FlowSources
deprecated import ThreadResourceAbuseFlow::PathGraph

/** Taint configuration of uncontrolled thread resource consumption. */
deprecated module ThreadResourceAbuseConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof ActiveThreatModelSource }

  predicate isSink(DataFlow::Node sink) { sink instanceof PauseThreadSink }

  predicate isAdditionalFlowStep(DataFlow::Node pred, DataFlow::Node succ) {
    any(ThreadResourceAbuseAdditionalTaintStep c).step(pred, succ)
  }

  predicate isBarrier(DataFlow::Node node) {
    exists(
      MethodCall ma // Math.min(sleepTime, MAX_INTERVAL)
    |
      ma.getMethod().hasQualifiedName("java.lang", "Math", "min") and
      node.asExpr() = ma.getAnArgument()
    )
    or
    node instanceof LessThanSanitizer // if (sleepTime > 0 && sleepTime < 5000) { ... }
  }
}

deprecated module ThreadResourceAbuseFlow = TaintTracking::Global<ThreadResourceAbuseConfig>;

deprecated query predicate problems(
  DataFlow::Node sinkNode, ThreadResourceAbuseFlow::PathNode source,
  ThreadResourceAbuseFlow::PathNode sink, string message1, DataFlow::Node sourceNode,
  string message2
) {
  ThreadResourceAbuseFlow::flowPath(source, sink) and
  sinkNode = sink.getNode() and
  message1 = "Vulnerability of uncontrolled resource consumption due to $@." and
  sourceNode = source.getNode() and
  message2 = "user-provided value"
}
