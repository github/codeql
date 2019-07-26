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

class ExtremeSourceFlowConfig extends DataFlow::Configuration {
  ExtremeSourceFlowConfig() { this = "ExtremeSourceFlowConfig" }

  override predicate isSource(DataFlow::Node source) { source.asExpr() instanceof ExtremeSource }

  override predicate isSink(DataFlow::Node sink) { sink(_, sink.asExpr()) }

  override predicate isBarrier(DataFlow::Node n) {
    n.getType() instanceof BooleanType or isSource(n)
  }
}

predicate sink(ArithExpr exp, VarAccess use) {
  use = exp.getAnOperand() and
  (
    not guardedAgainstUnderflow(exp, use) or
    not guardedAgainstOverflow(exp, use)
  ) and
  not overflowIrrelevant(exp) and
  not exp instanceof DivExpr
}

predicate query(
  DataFlow::PathNode source, DataFlow::PathNode sink, ArithExpr exp, Variable v,
  ExtremeValueField f, VarAccess use, ExtremeSource s, Type t
) {
  // `use` is the use of `v` in `exp`.
  use = exp.getAnOperand() and
  use = v.getAnAccess() and
  // An extreme field flows to `use`.
  f = s.getVariable() and
  any(ExtremeSourceFlowConfig conf).hasFlowPath(source, sink) and
  s = source.getNode().asExpr() and
  use = sink.getNode().asExpr() and
  t = s.getType() and
  // Division isn't a problem in this case.
  not exp instanceof DivExpr
}

from
  DataFlow::PathNode source, DataFlow::PathNode sink, ArithExpr exp, Variable v,
  ExtremeValueField f, VarAccess use, ExtremeSource s, string effect, Type t
where
  query(source, sink, exp, v, f, use, s, t) and
  // We're not guarded against the appropriate kind of flow error.
  (
    f instanceof MinValueField and not guardedAgainstUnderflow(exp, use) and effect = "underflow"
    or
    f instanceof MaxValueField and not guardedAgainstOverflow(exp, use) and effect = "overflow"
  ) and
  // Exclude widening conversions of extreme values due to binary numeric promotion (JLS 5.6.2)
  // unless there is an enclosing cast down to a narrower type.
  narrowerThanOrEqualTo(exp, t) and
  not overflowIrrelevant(exp)
select exp, source, sink,
  "Variable " + v.getName() + " is assigned an extreme value $@, and may cause an " + effect + ".",
  s, f.getName()
