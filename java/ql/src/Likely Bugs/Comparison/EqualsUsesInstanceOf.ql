/**
 * @name Possible inconsistency due to instanceof in equals
 * @description Implementations of 'equals' that use 'instanceof'
 *              to test the type of the argument and are further overridden in a subclass
 *              are likely to violate the 'equals' contract.
 * @kind problem
 * @problem.severity warning
 * @precision low
 * @id java/instanceof-in-equals
 * @tags reliability
 *       correctness
 */

import java

predicate instanceofInEquals(EqualsMethod m, InstanceOfExpr e) {
  m.fromSource() and
  e.getEnclosingCallable() = m and
  e.getExpr().(VarAccess).getVariable() = m.getParameter() and
  exists(RefType instanceofType |
    instanceofType = e.getSyntacticCheckedType() and
    not instanceofType.isFinal()
  )
}

from EqualsMethod m, InstanceOfExpr e, EqualsMethod m2
where
  (instanceofInEquals(m, e) or instanceofInEquals(m2, e)) and
  not m.getDeclaringType() instanceof TypeObject and
  exists(m.getBody()) and
  m2.fromSource() and
  exists(Method overridden | overridden.getSourceDeclaration() = m | m2.overrides+(overridden))
select e,
  "Possible violation of equals contract due to use of instanceof in $@ and/or overriding $@.", m,
  m.getDeclaringType().getName() + "." + m.getName(), m2,
  m2.getDeclaringType().getName() + "." + m2.getName()
