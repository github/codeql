/**
 * @name AV Rule 204.1
 * @description The value of an expression shall be the same under any order of evaluation that the standard permits. Except where noted, the order in which operators and subexpression are evaluated, as well as the order in which side effects take place, is unspecified.
 * @kind problem
 * @id cpp/jsf/av-rule-204-1
 * @problem.severity error
 * @tags correctness
 *       external/jsf
 */

import cpp

class SideEffectVariableExpr extends VariableAccess {
  SideEffectVariableExpr() {
    exists(CrementOperation o | o.getOperand() = this) or
    exists(AssignExpr e | e.getLValue() = this)
  }
}

predicate characteristicSequencePointExpr(Expr e, Expr c) {
  if
    exists(Expr p |
      p = e.getParent() and
      not p instanceof BinaryLogicalOperation and
      not p instanceof CommaExpr and
      not p instanceof ConditionalExpr
    )
  then characteristicSequencePointExpr(e.getParent(), c)
  else e = c
}

from SideEffectVariableExpr e, Expr c, Variable v, VariableAccess va
where
  e.getTarget() = v and
  va.getTarget() = v and
  characteristicSequencePointExpr(e, c) and
  characteristicSequencePointExpr(va, c) and
  va != e and
  not e.getParent().(AssignExpr).getLValue() = e
select c,
  "AV Rule 204.1: The value of an expression shall be the same under any order of evaluation that the standard permits"
