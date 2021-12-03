/**
 * @name Global could be static
 * @description Global variables that are not accessed outside their own file could be made static to promote information hiding.
 * @kind problem
 * @id cpp/power-of-10/global-could-be-static
 * @problem.severity recommendation
 * @precision low
 * @tags maintainability
 *       modularity
 *       external/powerof10
 */

import cpp

from GlobalVariable v
where
  forex(VariableAccess va | va.getTarget() = v | va.getFile() = v.getDefinitionLocation().getFile()) and
  not v.hasSpecifier("static") and
  strictcount(v.getAnAccess().getEnclosingFunction()) > 1 and // If = 1, variable should be function-scope.
  not v.getADeclarationEntry().getFile() instanceof HeaderFile // intended to be accessed elsewhere
select v,
  "The global variable " + v.getName() + " is not accessed outside of " + v.getFile().getBaseName() +
    " and could be made static."
