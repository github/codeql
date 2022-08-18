/**
 * @name Redundant override
 * @description Redundant override
 * @kind problem
 * @problem.severity warning
 * @id ql/redundant-override
 * @tags maintainability
 * @precision high
 */

import ql

private predicate redundantOverride(ClassPredicate pred, ClassPredicate sup) {
  pred.overrides(sup) and
  // Can be made more precise, but rules out overrides needed for disambiguation
  count(pred.getDeclaringType().getASuperType()) <= 1 and
  exists(MemberCall mc |
    mc.getBase() instanceof Super and
    mc.getTarget() = sup and
    not exists(pred.getQLDoc())
  |
    pred.getBody() =
      any(ComparisonFormula comp |
        comp.getOperator() = "=" and
        comp.getAnOperand() instanceof ResultAccess and
        comp.getAnOperand() = mc and
        pred.getReturnType() = sup.getReturnType()
      )
    or
    pred.getBody() = mc
  )
}

from ClassPredicate pred, ClassPredicate sup
where redundantOverride(pred, sup)
select pred, "Redundant override of $@ predicate", sup, "this"
