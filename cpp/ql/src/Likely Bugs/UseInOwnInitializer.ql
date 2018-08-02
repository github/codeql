/**
 * @name Variable used in its own initializer
 * @id cpp/use-in-own-initializer
 * @description Loading from a variable in its own initializer may lead to undefined behavior.
 * @kind problem
 * @problem.severity warning
 * @precision high
 * @tags maintainability
 *       correctness
 */

import cpp

from Initializer init, Variable v, VariableAccess va
where init.getDeclaration() = v
  and va.getTarget() = v
  and va.getParent*() = init
  and (
    va.hasLValueToRValueConversion() or
    exists (Assignment assn | assn.getLValue() = va) or
    exists (CrementOperation crement | crement.getAnOperand() = va)
  )
  and not va.isUnevaluated()
  and not (
    va.getParent() = init and
    exists(MacroInvocation mi |
      va = mi.getExpr()
    )
  )
  and not (
    va.getEnclosingStmt().isInMacroExpansion()
  )
select va, v.getName() + " is used in its own initializer."
