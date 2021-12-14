/**
 * @name Function declared in block
 * @description Functions should always be declared at file scope. It is confusing to declare a function at block scope, and the visibility of the function is not what would be expected.
 * @kind problem
 * @problem.severity recommendation
 * @precision very-high
 * @id cpp/function-in-block
 * @tags maintainability
 *       readability
 *       external/jsf
 */

import cpp

from DeclStmt ds
where
  ds.getADeclaration() instanceof Function and
  not ds.isInMacroExpansion() and
  not exists(MacroInvocation mi | mi.getLocation() = ds.getADeclarationEntry().getLocation())
select ds, "Functions should be declared at file scope, not inside blocks."
