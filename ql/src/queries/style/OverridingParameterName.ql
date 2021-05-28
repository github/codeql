/**
 * @name Using a different paramater name than used in the super-predicate.
 * @description Using another parameter can be an indication of copy-pasted code, or a mistake.
 * @kind problem
 * @problem.severity warning
 * @id ql/override-parameter-name
 * @tags correctness
 *       maintainability
 * @precision medium
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
  // avoid duplicated alerts with `ql/override-swapped-name`
  not exists(int other | other != index |
    sup.getParameter(other).getName() = pred.getParameter(index).getName()
  )
select parameter, pred.getParameter(index).getName() + " was $@ in the super class.",
  sup.getParameter(index), "named " + sup.getParameter(index).getName()
