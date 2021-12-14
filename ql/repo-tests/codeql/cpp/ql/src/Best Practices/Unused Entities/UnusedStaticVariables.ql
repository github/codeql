/**
 * @name Unused static variable
 * @description A static variable that is never accessed may be an indication
 *              that the code is incomplete or has a typo.
 * @kind problem
 * @problem.severity recommendation
 * @precision high
 * @id cpp/unused-static-variable
 * @tags efficiency
 *       useless-code
 *       external/cwe/cwe-563
 */

import cpp

predicate declarationHasSideEffects(Variable v) {
  exists(Class c | c = v.getUnspecifiedType() | c.hasConstructor() or c.hasDestructor())
}

from Variable v
where
  v.isStatic() and
  v.hasDefinition() and
  not v.isConstexpr() and
  not exists(VariableAccess a | a.getTarget() = v) and
  not v instanceof MemberVariable and
  not declarationHasSideEffects(v) and
  not v.getAnAttribute().hasName("used") and
  not v.getAnAttribute().hasName("unused")
select v, "Static variable " + v.getName() + " is never read"
