/**
 * @name Unchecked return value used as offset
 * @description Using a return value as a pointer offset without checking that the value is positive
 *               may lead to buffer overruns.
 * @kind problem
 * @id cpp/missing-negativity-test
 * @problem.severity warning
 * @tags reliability
 *       security
 *       external/cwe/cwe-823
 */

import cpp
import Negativity

class IntegralReturnValue extends FunctionCall {
  IntegralReturnValue() { this.getType().getUnderlyingType() instanceof IntegralType }

  predicate isChecked() {
    exists(ControlFlowNode def, ControlFlowNode test, Variable v |
      exprDefinition(v, def, this) and
      definitionReaches(def, test) and
      errorSuccessor(v, test.getASuccessor())
    )
  }
}

class FunctionWithNegativeReturn extends Function {
  FunctionWithNegativeReturn() {
    this.getType().getUnderlyingType() instanceof IntegralType and
    (
      exists(ReturnStmt ret |
        ret.getExpr().getValue().toInt() < 0 and
        ret.getEnclosingFunction() = this
      )
      or
      count(IntegralReturnValue val | val.getTarget() = this and val.isChecked()) * 100 /
        count(IntegralReturnValue val | val.getTarget() = this) >= 80
    )
  }
}

predicate dangerousUse(IntegralReturnValue val, Expr use) {
  exists(ArrayExpr ae | ae.getArrayOffset() = val and use = val)
  or
  exists(StackVariable v, ControlFlowNode def, ArrayExpr ae |
    exprDefinition(v, def, val) and
    use = ae.getArrayOffset() and
    not boundsChecked(v, use) and
    definitionUsePair(v, def, use)
  )
  or
  use.getParent().(AddExpr).getAnOperand() = val and
  val = use and
  use.getType().getUnderlyingType() instanceof PointerType
  or
  exists(StackVariable v, ControlFlowNode def, AddExpr add |
    exprDefinition(v, def, val) and
    definitionUsePair(v, def, use) and
    add.getAnOperand() = use and
    not boundsChecked(v, use) and
    add.getType().getUnderlyingType() instanceof PointerType
  )
}

from FunctionWithNegativeReturn f, IntegralReturnValue val, Expr dangerous
where
  val.getTarget() = f and
  dangerousUse(val, dangerous)
select dangerous,
  "Dangerous use of possibly negative value (return value of '" + f.getName() + "')."
