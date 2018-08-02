/**
 * @name Declaration hides parameter
 * @description A local variable hides a parameter. This may be confusing. Consider renaming one of them.
 * @kind problem
 * @problem.severity recommendation
 * @precision very-high
 * @id cpp/declaration-hides-parameter
 * @tags maintainability
 *       readability
 */
import cpp


/* Names of parameters in the implementation of a function.
   Notice that we need to exclude parameter names used in prototype
   declarations and only include the ones from the actual definition.
   We also exclude names from functions that have multiple definitions.
   This should not happen in a single application but since we
   have a system wide view it is likely to happen for instance for
   the main function. */
ParameterDeclarationEntry functionParameterNames(Function f, string name) {
  exists(FunctionDeclarationEntry fe |
    result.getFunctionDeclarationEntry() = fe
    and fe.getFunction() = f
    and fe.getLocation() = f.getDefinitionLocation()
    and strictcount(f.getDefinitionLocation()) = 1
    and result.getName() = name
  )
}

from Function f, LocalVariable lv, ParameterDeclarationEntry pde
where f = lv.getFunction() and
      pde = functionParameterNames(f, lv.getName()) and
      not lv.isInMacroExpansion()
select lv, "Local variable '"+ lv.getName() +"' hides a $@.",
       pde, "parameter of the same name"
