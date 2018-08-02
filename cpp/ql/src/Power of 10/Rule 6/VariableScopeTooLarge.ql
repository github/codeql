/**
 * @name Variable scope too large
 * @description Global and file-scope variables that are accessed by only one function should be scoped within that function.
 * @kind problem
 * @id cpp/power-of-10/variable-scope-too-large
 * @problem.severity warning
 */

import cpp

from GlobalVariable v, Function f
where v.getAnAccess().getEnclosingFunction() = f and
      strictcount(v.getAnAccess().getEnclosingFunction()) = 1
select v, "The variable " + v.getName() + " is only accessed in $@ and should be scoped accordingly.", f, f.getName()
