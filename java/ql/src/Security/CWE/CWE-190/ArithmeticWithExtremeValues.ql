/**
 * @name Use of extreme values in arithmetic expression
 * @description If a variable is assigned the maximum or minimum value for that variable's type and
 *              is then used in an arithmetic expression, this may result in an overflow.
 * @kind path-problem
 * @problem.severity recommendation
 * @precision medium
 * @id java/extreme-value-arithmetic
 * @tags security
 *       reliability
 *       external/cwe/cwe-190
 *       external/cwe/cwe-191
 */

import java
import semmle.code.java.dataflow.DataFlow
import ArithmeticCommon
import DataFlow::PathGraph

abstract class ExtremeValueField extends Field {
  ExtremeValueField() { getType() instanceof IntegralType }
}

class MinValueField extends ExtremeValueField {
  MinValueField() { this.getName() = "MIN_VALUE" }
}

class MaxValueField extends ExtremeValueField {
  MaxValueField() { this.getName() = "MAX_VALUE" }
}

class ExtremeSource extends VarAccess {
  ExtremeSource() { this.getVariable() instanceof ExtremeValueField }
}

class MaxValueFlowConfig extends DataFlow::Configuration {
  MaxValueFlowConfig() { this = "MaxValueFlowConfig" }

  override predicate isSource(DataFlow::Node source) {
    source.asExpr().(ExtremeSource).getVariable() instanceof MaxValueField
  }

  override predicate isSink(DataFlow::Node sink) { overflowSink(_, sink.asExpr()) }

  override predicate isBarrierIn(DataFlow::Node n) { isSource(n) }

  override predicate isBarrier(DataFlow::Node n) { overflowBarrier(n) }
}

class MinValueFlowConfig extends DataFlow::Configuration {
  MinValueFlowConfig() { this = "MinValueFlowConfig" }

  override predicate isSource(DataFlow::Node source) {
    source.asExpr().(ExtremeSource).getVariable() instanceof MinValueField
  }

  override predicate isSink(DataFlow::Node sink) { underflowSink(_, sink.asExpr()) }

  override predicate isBarrierIn(DataFlow::Node n) { isSource(n) }

  override predicate isBarrier(DataFlow::Node n) { underflowBarrier(n) }
}

predicate query(
  DataFlow::PathNode source, DataFlow::PathNode sink, ArithExpr exp, string effect, Type srctyp
) {
  (
    any(MaxValueFlowConfig c).hasFlowPath(source, sink) and
    overflowSink(exp, sink.getNode().asExpr()) and
    effect = "overflow"
    or
    any(MinValueFlowConfig c).hasFlowPath(source, sink) and
    underflowSink(exp, sink.getNode().asExpr()) and
    effect = "underflow"
  ) and
  srctyp = source.getNode().asExpr().getType()
}

from
  DataFlow::PathNode source, DataFlow::PathNode sink, ArithExpr exp, Variable v, ExtremeSource s,
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
