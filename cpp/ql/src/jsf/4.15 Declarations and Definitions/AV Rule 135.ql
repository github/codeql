/**
 * @name Hiding identifiers
 * @description Identifiers in an inner scope should not use the same name as an identifier in an outer scope, and therefore hide that identifier.
 * @kind problem
 * @id cpp/jsf/av-rule-135
 * @problem.severity recommendation
 * @tags maintainability
 *       external/jsf
 */

import cpp
import Best_Practices.Hiding.Shadowing

// Shadowing globals by locals or parameters. Only in the same file;
// otherwise the rule is violated too often
class LocalVariableOrParameter extends Variable {
  LocalVariableOrParameter() { this instanceof LocalVariable or this instanceof Parameter }

  predicate shadowsGlobal(GlobalVariable gv) {
    this.getName() = gv.getName() and this.getFile() = gv.getFile()
  }
}

// Shadowing parameters by locals
predicate localShadowsParameter(LocalVariable lv, Parameter p) {
  p.getName() = lv.getName() and
  p.getFunction() = lv.getFunction()
}

from Variable v, Variable shadowed
where
  not v.getParentScope().(BlockStmt).isInMacroExpansion() and
  (
    v.(LocalVariableOrParameter).shadowsGlobal(shadowed) or
    localShadowsParameter(v, shadowed) or
    shadowing(v, shadowed)
  )
select v, "Identifiers in an inner scope should not hide identifiers in an outer scope"
