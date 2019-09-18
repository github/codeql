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

/**
 * Gets the parameter of `f` with name `name`, which has to come from the
 * _definition_ of `f` and not a prototype declaration.
 * We also exclude names from functions that have multiple definitions.
 * This should not happen in a single application but since we
 * have a system wide view it is likely to happen for instance for
 * the main function.
 */
ParameterDeclarationEntry functionParameterNames(Function f, string name) {
  exists(FunctionDeclarationEntry fe |
    result.getFunctionDeclarationEntry() = fe and
    fe.getFunction() = f and
    fe.getLocation() = f.getDefinitionLocation() and
    result.getFile() = fe.getFile() and // Work around CPP-331
    strictcount(f.getDefinitionLocation()) = 1 and
    result.getName() = name
  )
}

/** Gets a local variable in `f` with name `name`. */
pragma[nomagic]
LocalVariable localVariableNames(Function f, string name) {
  name = result.getName() and
  f = result.getFunction()
}

from Function f, LocalVariable lv, ParameterDeclarationEntry pde, string name
where
  lv = localVariableNames(f, name) and
  pde = functionParameterNames(f, name) and
  not lv.isInMacroExpansion()
select lv, "Local variable '" + lv.getName() + "' hides a $@.", pde, "parameter of the same name"
