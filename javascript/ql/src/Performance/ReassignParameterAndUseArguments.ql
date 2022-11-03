/**
 * @name Parameter reassigned in function that uses arguments
 * @description A function that reassigns one of its parameters and also uses the arguments object
 *              may not be optimized properly.
 * @kind problem
 * @problem.severity recommendation
 * @id js/parameter-reassignment-with-arguments
 * @tags efficiency
 *       maintainability
 * @precision medium
 */

import javascript

from Function f, SimpleParameter p, VarAccess assgn
where
  p = f.getAParameter() and
  f.usesArgumentsObject() and
  assgn = p.getVariable().getAnAccess() and
  assgn.isLValue()
select p,
  "This parameter is reassigned $@, " +
    "which may prevent optimization because the surrounding function " +
    "uses the arguments object.", assgn, "here"
