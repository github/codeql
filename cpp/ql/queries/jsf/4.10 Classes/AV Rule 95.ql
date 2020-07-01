/**
 * @name Redefined default parameter
 * @description An inherited default parameter shall never be redefined. Default values are bound statically which is confusing when combined with dynamically bound function calls.
 * @kind problem
 * @problem.severity error
 * @precision high
 * @id cpp/redefined-default-parameter
 * @tags maintainability
 *       readability
 *       external/jsf
 */

import cpp

predicate memberParameterWithDefault(
  MemberFunction f, int ix, Parameter p, Expr initExpr, string initValue
) {
  f.getParameter(ix) = p and
  initExpr = p.getInitializer().getExpr() and
  initValue = initExpr.getValue()
}

from
  Parameter p, Parameter superP, MemberFunction subF, MemberFunction superF, int i, Expr subExpr,
  string subValue, string superValue
where
  memberParameterWithDefault(subF, i, p, subExpr, subValue) and
  subF.overrides(superF) and
  memberParameterWithDefault(superF, i, superP, _, superValue) and
  subValue != superValue
select subExpr,
  "Parameter " + p.getName() + " redefines its default value to " + subValue +
    " from the inherited default value " + superValue + " (in " +
    superF.getDeclaringType().getName() +
    ").\nThe default value will be resolved statically, not by dispatch, so this can cause confusion."
