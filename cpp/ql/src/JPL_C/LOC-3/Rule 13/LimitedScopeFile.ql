/**
 * @name Global could be static
 * @description Global variables that are not accessed outside their own file should be made static to promote information hiding.
 * @kind problem
 * @id cpp/jpl-c/limited-scope-file
 * @problem.severity warning
 */

import cpp

from GlobalVariable v
where forex(VariableAccess va | va.getTarget() = v | va.getFile() = v.getDefinitionLocation().getFile())
      and not v.hasSpecifier("static")
      and strictcount(v.getAnAccess().getEnclosingFunction()) > 1 // If = 1, variable should be function-scope.
select v, "The global variable " + v.getName() + " is not accessed outside of " + v.getFile().getBaseName()
      + " and could be made static."
