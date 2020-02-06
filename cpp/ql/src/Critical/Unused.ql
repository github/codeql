/**
 * @name Variable is assigned a value that is never read
 * @description Assigning a value to a variable that is not used may indicate an error in the code.
 * @kind problem
 * @id cpp/unused-variable
 * @problem.severity warning
 * @tags maintainability
 *       external/cwe/cwe-563
 */

import cpp

// Sometimes it is useful to have a class which is instantiated (on the stack)
// but not otherwise used. This is usually to perform some task and have that
// task automatically reversed when the current scope is left. For example,
// sometimes locking is done this way.
//
// Obviously, such instantiations should not be treated as unused values.
class ScopeUtilityClass extends Class {
  Call getAUse() { result = this.getAConstructor().getACallToThisFunction() }
}

from StackVariable v, ControlFlowNode def
where
  definition(v, def) and
  not definitionUsePair(v, def, _) and
  not v.getAnAccess().isAddressOfAccess() and
  // parameter initializers are not in the call-graph at the moment
  not v.(Parameter).getInitializer().getExpr() = def and
  not v.getType().getUnderlyingType() instanceof ReferenceType and
  not exists(ScopeUtilityClass util | def = util.getAUse()) and
  not def.isInMacroExpansion()
select def, "Variable '" + v.getName() + "' is assigned a value that is never used"
