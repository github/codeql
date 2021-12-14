/**
 * @name Local variable hides global variable
 * @description A local variable or parameter that hides a global variable of the same name. This may be confusing. Consider renaming one of the variables.
 * @kind problem
 * @problem.severity recommendation
 * @precision very-high
 * @id cpp/local-variable-hides-global-variable
 * @tags maintainability
 *       readability
 */

import cpp

class LocalVariableOrParameter extends VariableDeclarationEntry {
  LocalVariableOrParameter() {
    this.getVariable() instanceof LocalScopeVariable and
    (
      // we only need to report parameters hiding globals when the clash is with the parameter
      // name as used in the function definition.  The parameter name used in any other function
      // declaration is harmless.
      this instanceof ParameterDeclarationEntry
      implies
      exists(this.(ParameterDeclarationEntry).getFunctionDeclarationEntry().getBlock())
    )
  }

  string type() {
    if this.getVariable() instanceof Parameter
    then result = "Parameter "
    else result = "Local variable "
  }
}

from LocalVariableOrParameter lv, GlobalVariable gv
where
  lv.getName() = gv.getName() and
  lv.getFile() = gv.getFile()
select lv, lv.type() + gv.getName() + " hides $@ with the same name.", gv, "a global variable"
