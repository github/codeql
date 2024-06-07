/**
 * @name Use of extreme values in arithmetic expression
 * @description If a variable is assigned the maximum or minimum value for that variable's type and
 *              is then used in an arithmetic expression, this may result in an overflow.
 * @kind path-problem
 * @problem.severity recommendation
 * @security-severity 8.6
 * @precision medium
 * @id java/extreme-value-arithmetic
 * @tags security
 *       reliability
 *       external/cwe/cwe-190
 *       external/cwe/cwe-191
 */

import java
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.security.ArithmeticCommon
import semmle.code.java.security.ArithmeticWithExtremeValuesQuery
import Flow::PathGraph

module Flow =
  DataFlow::MergePathGraph<MaxValueFlow::PathNode, MinValueFlow::PathNode, MaxValueFlow::PathGraph,
    MinValueFlow::PathGraph>;

predicate query(
  Flow::PathNode source, Flow::PathNode sink, ArithExpr exp, string effect, Type srctyp
) {
  (
    MaxValueFlow::flowPath(source.asPathNode1(), sink.asPathNode1()) and
    overflowSink(exp, sink.getNode().asExpr()) and
    effect = "overflow"
    or
    MinValueFlow::flowPath(source.asPathNode2(), sink.asPathNode2()) and
    underflowSink(exp, sink.getNode().asExpr()) and
    effect = "underflow"
  ) and
  srctyp = source.getNode().asExpr().getType()
}

from
  Flow::PathNode source, Flow::PathNode sink, ArithExpr exp, Variable v, ExtremeSource s,
  string effect, Type srctyp
where
  query(source, sink, exp, effect, srctyp) and
  // Exclude widening conversions of extreme values due to binary numeric promotion (JLS 5.6.2)
  // unless there is an enclosing cast down to a narrower type.
  narrowerThanOrEqualTo(exp, srctyp) and
  v = sink.getNode().asExpr().(VarAccess).getVariable() and
  s = source.getNode().asExpr()
select exp, source, sink,
  "Variable " + v.getName() + " is assigned an extreme value $@, and may cause an " + effect + ".",
  s, s.getVariable().getName()
