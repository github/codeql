/**
 * @name Variable scope too large
 * @description Global and file-scope variables that are accessed by only one function should be scoped within that function.
 * @kind problem
 * @id cpp/jpl-c/limited-scope-function
 * @problem.severity recommendation
 * @precision low
 * @tags maintainability
 *       external/jpl
 */

import cpp

from GlobalVariable v, Function f
where
  v.getAnAccess().getEnclosingFunction() = f and
  strictcount(v.getAnAccess().getEnclosingFunction()) = 1 and
  forall(VariableAccess a | a = v.getAnAccess() | exists(a.getEnclosingFunction())) and
  not v.getADeclarationEntry().getFile() instanceof HeaderFile // intended to be accessed elsewhere
select v,
  "The variable " + v.getName() + " is only accessed in $@ and should be scoped accordingly.", f,
  f.getName()
