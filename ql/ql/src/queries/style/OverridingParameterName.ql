/**
 * @name Using a different parameter name than used in the super-predicate.
 * @description Using another parameter can be an indication of copy-pasted code, or a mistake.
 * @kind problem
 * @problem.severity warning
 * @id ql/override-parameter-name
 * @tags correctness
 *       maintainability
 * @precision low
 */

import ql

pragma[noinline]
private predicate getAnOverridingParameter(
  ClassPredicate pred, ClassPredicate sup, VarDecl parameter, int index
) {
  pred.overrides(sup) and
  parameter = pred.getParameter(index)
}

pragma[nomagic]
string getParameterName(ClassPredicate pred, int index) {
  pred.getParameter(index).getName() = result
}

from ClassPredicate pred, ClassPredicate sup, VarDecl parameter, int index
where
  getAnOverridingParameter(pred, sup, parameter, index) and
  getParameterName(sup, index) != getParameterName(pred, index) and
  // avoid duplicated alerts with `ql/override-swapped-name`
  not exists(int other | other != index |
    getParameterName(sup, other) = getParameterName(pred, index)
  )
select parameter, pred.getParameter(index).getName() + " was $@ in the super class.",
  sup.getParameter(index), "named " + sup.getParameter(index).getName()
