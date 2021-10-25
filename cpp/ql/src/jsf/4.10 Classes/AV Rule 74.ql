/**
 * @name AV Rule 74
 * @description Initialization of nonstatic class members will be performed through the
 *              member initialization list rather than through assignment in the body of
 *              a constructor.
 * @kind problem
 * @id cpp/jsf/av-rule-74
 * @problem.severity warning
 * @tags correctness
 *       external/jsf
 */

import cpp

// find assignment to non-static member variable in constructor, where that variable is
// not also initialised through the member initialisation list
from Assignment ass, Field mv, Constructor ctor
where
  ass.getEnclosingFunction() = ctor and
  mv.getDeclaringType() = ctor.getDeclaringType() and
  ass.getLValue().(Access).getTarget() = mv and
  not exists(ConstructorFieldInit cfi | cfi = ctor.getAnInitializer() | cfi.getTarget() = mv)
select ass,
  "AV Rule 74: Nonstatic members will be initialized through the member initialization list, not through assignment."
