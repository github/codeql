/**
 * @name AV Rule 69
 * @description A member function that does not affect the state of an object will be
 *              declared const.
 * @kind problem
 * @id cpp/jsf/av-rule-69
 * @problem.severity warning
 * @tags maintainability
 *       external/jsf
 */

import cpp

from MemberFunction mf
where
  mf.fromSource() and
  mf.hasDefinition() and
  not mf instanceof Constructor and
  not exists(VariableAccess va |
    va.isLValue() and
    va.getEnclosingFunction() = mf and
    (
      va.getTarget() instanceof MemberVariable or
      va.getTarget() instanceof GlobalVariable
    )
  ) and
  forall(Call c | c.getEnclosingFunction() = mf | c.isPure()) and
  not mf.hasSpecifier("const")
select mf,
  "AV Rule 69: A member function that does not affect the state of an object will be declared const."
