/**
 * @name Uncontrolled data used in path expression
 * @description Accessing paths influenced by users can allow an attacker to access unexpected resources.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 7.5
 * @precision high
 * @id java/path-injection
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
import DataFlow::PathGraph
import TaintedPathCommon

predicate containsDotDotSanitizer(Guard g, Expr e, boolean branch) {
  exists(MethodAccess contains | g = contains |
    contains.getMethod().hasName("contains") and
    contains.getAnArgument().(StringLiteral).getValue() = ".." and
    e = contains.getQualifier() and
    branch = false
  )
}

class TaintedPathConfig extends TaintTracking::Configuration {
  TaintedPathConfig() { this = "TaintedPathConfig" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) {
    (
      sink.asExpr() = any(PathCreation p).getAnInput()
      or
      sinkNode(sink, "create-file")
    ) and
    not guarded(sink.asExpr())
  }

  override predicate isSanitizer(DataFlow::Node node) {
    exists(Type t | t = node.getType() | t instanceof BoxedType or t instanceof PrimitiveType)
    or
    node = DataFlow::BarrierGuard<containsDotDotSanitizer/3>::getABarrierNode()
  }
}

/**
 * Gets the data-flow node at which to report a path ending at `sink`.
 *
 * Previously this query flagged alerts exclusively at `PathCreation` sites,
 * so to avoid perturbing existing alerts, where a `PathCreation` exists we
 * continue to report there; otherwise we report directly at `sink`.
 */
DataFlow::Node getReportingNode(DataFlow::Node sink) {
  any(TaintedPathConfig c).hasFlowTo(sink) and
  if exists(PathCreation pc | pc.getAnInput() = sink.asExpr())
  then result.asExpr() = any(PathCreation pc | pc.getAnInput() = sink.asExpr())
  else result = sink
}

from DataFlow::PathNode source, DataFlow::PathNode sink, TaintedPathConfig conf
where conf.hasFlowPath(source, sink)
select getReportingNode(sink.getNode()), source, sink, "$@ flows to here and is used in a path.",
  source.getNode(), "User-provided value"
