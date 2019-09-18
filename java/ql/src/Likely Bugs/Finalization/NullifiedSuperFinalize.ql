/**
 * @name Finalizer inconsistency
 * @description A 'finalize' method that does not call 'super.finalize' may leave
 *              cleanup actions undone.
 * @kind problem
 * @problem.severity error
 * @precision medium
 * @id java/missing-super-finalize
 * @tags reliability
 *       maintainability
 *       external/cwe/cwe-568
 */

import java

from FinalizeMethod m, Class c, FinalizeMethod mSuper, Class cSuper
where
  m.getDeclaringType() = c and
  mSuper.getDeclaringType() = cSuper and
  c.getASupertype+() = cSuper and
  not cSuper instanceof TypeObject and
  not exists(m.getBody().getAChild())
select m, "Finalize in " + c.getName() + " nullifies finalize in " + cSuper.getName() + "."
