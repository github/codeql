/**
 * @name Local variable hides global variable
 * @description A local variable or parameter that hides a global variable of the same name.
 * @kind problem
 * @id cpp/jpl-c/limited-scope-local-hides-global
 * @problem.severity recommendation
 * @tags maintainability
 *       readability
 *       external/jpl
 */

import cpp

class LocalVariableOrParameter extends Variable {
  LocalVariableOrParameter() {
    this instanceof LocalVariable
    or
    // A function declaration (i.e. "int foo(int bar);") doesn't usefully
    // shadow globals; the parameter should be on the version of the function
    // that has a body.
    exists(Parameter p | p = this |
      p.getFunction().getDefinitionLocation().getFile() = this.getFile() and
      exists(p.getFunction().getBlock())
    )
  }

  string type() {
    if this instanceof Parameter then result = "Parameter " else result = "Local variable "
  }
}

from LocalVariableOrParameter lv, GlobalVariable gv
where
  lv.getName() = gv.getName() and
  lv.getFile() = gv.getFile()
select lv, lv.type() + lv.getName() + " hides the global variable $@.", gv, gv.getName()
