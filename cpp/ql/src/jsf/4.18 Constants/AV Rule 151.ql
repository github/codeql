/**
 * @name AV Rule 151
 * @description Numeric values in code will not be used; symbolic values will be used instead.
 * @kind problem
 * @id cpp/jsf/av-rule-151
 * @problem.severity recommendation
 * @tags maintainability
 *       external/jsf
 */

import cpp

from Literal l
where
  l.fromSource() and
  l.getType() instanceof ArithmeticType and
  not l.isInMacroExpansion() and
  not l.getParent() instanceof ArrayExpr and
  not exists(Variable v | v.getInitializer().getExpr() = l) and
  not exists(Assignment a |
    a.getLValue() instanceof ArrayExpr and
    a.getRValue() = l and
    a.getControlFlowScope() instanceof Constructor
  ) and
  not l.getValue() = "0" and
  not l.getValue() = "1"
select l,
  "AV Rule 151: Numeric values in code will not be used; symbolic values will be used instead."
