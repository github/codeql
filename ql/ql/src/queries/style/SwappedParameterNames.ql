/**
 * @name Swapped parameter names in overriding predicate.
 * @description Swapping the parameter names in an overriding method indicates an implementation mistake.
 * @kind problem
 * @problem.severity error
 * @id ql/override-swapped-name
 * @tags correctness
 *       maintainability
 * @precision high
 */

import ql

pragma[noinline]
private predicate getAnOverridingParameter(
  ClassPredicate pred, ClassPredicate sup, VarDecl parameter, int index
) {
  pred.overrides(sup) and
  parameter = pred.getParameter(index)
}

from ClassPredicate pred, ClassPredicate sup, VarDecl parameter, int index
where
  getAnOverridingParameter(pred, sup, parameter, index) and
  sup.getParameter(index).getName() != pred.getParameter(index).getName() and
  exists(int other | other != index |
    sup.getParameter(other).getName() = pred.getParameter(index).getName()
  )
select parameter, pred.getParameter(index).getName() + " was $@ in the super class.",
  sup.getParameter(index), "named " + sup.getParameter(index).getName()
