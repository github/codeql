/**
 * @name Local-user-controlled data in path expression
 * @description Accessing paths influenced by users can allow an attacker to access unexpected resources.
 * @kind path-problem
 * @problem.severity recommendation
 * @security-severity 7.5
 * @precision medium
 * @id java/path-injection-local
 * @tags security
 *       external/cwe/cwe-022
 *       external/cwe/cwe-023
 *       external/cwe/cwe-036
 *       external/cwe/cwe-073
 */

import java
import semmle.code.java.dataflow.FlowSources
private import semmle.code.java.dataflow.ExternalFlow
import semmle.code.java.security.PathCreation
import semmle.code.java.security.PathSanitizer
import TaintedPathCommon

module TaintedPathLocalConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof LocalUserInput }

  predicate isSink(DataFlow::Node sink) {
    sink.asExpr() = any(PathCreation p).getAnInput()
    or
    sinkNode(sink, "create-file")
  }

  predicate isBarrier(DataFlow::Node sanitizer) {
    sanitizer.getType() instanceof BoxedType or
    sanitizer.getType() instanceof PrimitiveType or
    sanitizer.getType() instanceof NumberType or
    sanitizer instanceof PathInjectionSanitizer
  }

  predicate isAdditionalFlowStep(DataFlow::Node n1, DataFlow::Node n2) {
    any(TaintedPathAdditionalTaintStep s).step(n1, n2)
  }
}

module TaintedPathLocalFlow = TaintTracking::Make<TaintedPathLocalConfig>;

import TaintedPathLocalFlow::PathGraph

/**
 * Gets the data-flow node at which to report a path ending at `sink`.
 *
 * Previously this query flagged alerts exclusively at `PathCreation` sites,
 * so to avoid perturbing existing alerts, where a `PathCreation` exists we
 * continue to report there; otherwise we report directly at `sink`.
 */
DataFlow::Node getReportingNode(DataFlow::Node sink) {
  TaintedPathLocalFlow::hasFlowTo(sink) and
  if exists(PathCreation pc | pc.getAnInput() = sink.asExpr())
  then result.asExpr() = any(PathCreation pc | pc.getAnInput() = sink.asExpr())
  else result = sink
}

from TaintedPathLocalFlow::PathNode source, TaintedPathLocalFlow::PathNode sink
where TaintedPathLocalFlow::hasFlowPath(source, sink)
select getReportingNode(sink.getNode()), source, sink, "This path depends on a $@.",
  source.getNode(), "user-provided value"
