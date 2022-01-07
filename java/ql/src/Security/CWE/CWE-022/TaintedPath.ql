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
import semmle.code.java.security.PathCreation
import DataFlow::PathGraph
import TaintedPathCommon

class ContainsDotDotSanitizer extends DataFlow::BarrierGuard {
  ContainsDotDotSanitizer() {
    this.(MethodAccess).getMethod().hasName("contains") and
    this.(MethodAccess).getAnArgument().(StringLiteral).getValue() = ".."
  }

  override predicate checks(Expr e, boolean branch) {
    e = this.(MethodAccess).getQualifier() and branch = false
  }
}

class TaintedPathConfig extends TaintTracking::Configuration {
  TaintedPathConfig() { this = "TaintedPathConfig" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) {
    exists(Expr e | e = sink.asExpr() | e = any(PathCreation p).getAnInput() and not guarded(e))
  }

  override predicate isSanitizer(DataFlow::Node node) {
    exists(Type t | t = node.getType() | t instanceof BoxedType or t instanceof PrimitiveType)
  }

  override predicate isSanitizerGuard(DataFlow::BarrierGuard guard) {
    guard instanceof ContainsDotDotSanitizer
  }
}

from DataFlow::PathNode source, DataFlow::PathNode sink, PathCreation p, TaintedPathConfig conf
where
  sink.getNode().asExpr() = p.getAnInput() and
  conf.hasFlowPath(source, sink)
select p, source, sink, "$@ flows to here and is used in a path.", source.getNode(),
  "User-provided value"
