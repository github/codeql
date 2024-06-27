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
import ThreadResourceAbuse
import semmle.code.java.dataflow.FlowSources
import ThreadResourceAbuseFlow::PathGraph

/** Taint configuration of uncontrolled thread resource consumption. */
module ThreadResourceAbuseConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof ThreatModelFlowSource }

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

module ThreadResourceAbuseFlow = TaintTracking::Global<ThreadResourceAbuseConfig>;

from ThreadResourceAbuseFlow::PathNode source, ThreadResourceAbuseFlow::PathNode sink
where ThreadResourceAbuseFlow::flowPath(source, sink)
select sink.getNode(), source, sink,
  "Vulnerability of uncontrolled resource consumption due to $@.", source.getNode(),
  "user-provided value"
